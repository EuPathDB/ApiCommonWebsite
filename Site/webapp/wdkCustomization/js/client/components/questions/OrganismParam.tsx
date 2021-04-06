import React, { Suspense, useCallback, useEffect, useMemo, useRef } from 'react';
import { useLocation } from 'react-router';

import { Link, Loading } from '@veupathdb/wdk-client/lib/Components';
import { Props as CheckboxTreeProps } from '@veupathdb/wdk-client/lib/Components/CheckboxTree/CheckboxTree';

import { pruneDescendantNodes } from '@veupathdb/wdk-client/lib/Utils/TreeUtils';
import { EnumParam, Parameter, TreeBoxEnumParam, TreeBoxVocabNode } from '@veupathdb/wdk-client/lib/Utils/WdkModel';

import ParamComponent from '@veupathdb/wdk-client/lib/Views/Question/ParameterComponent';
import EnumParamModule from '@veupathdb/wdk-client/lib/Views/Question/Params/EnumParam';
import {
  isMultiPick,
  toMultiValueArray,
  toMultiValueString,
} from '@veupathdb/wdk-client/lib/Views/Question/Params/EnumParamUtils';
import TreeBoxEnumParamComponent, {
  State,
} from '@veupathdb/wdk-client/lib/Views/Question/Params/TreeBoxEnumParam';
import { Props, isPropsType } from '@veupathdb/wdk-client/lib/Views/Question/Params/Utils';

import { pruneNodesWithSingleExtendingChild } from '@veupathdb/web-common/lib/util/organisms';

import { usePreferredOrganismsState } from '@veupathdb/preferred-organisms/lib/hooks/preferredOrganisms';
import {
  useRenderOrganismNode,
  useReferenceStrains,
  useOrganismSearchPredicate
} from '@veupathdb/preferred-organisms/lib/hooks/referenceStrains';

import './OrganismParam.scss';

const ORGANISM_PROPERTIES_KEY = 'organismProperties';

const PRUNE_NODES_WITH_SINGLE_EXTENDING_CHILD_PROPERTY = 'pruneNodesWithSingleExtendingChild';
const SHOW_ONLY_PREFERRED_ORGANISMS_PROPERTY = 'showOnlyPreferredOrganisms';
const HIGHLIGHT_REFERENCE_ORGANISMS_PROPERTY = 'highlightReferenceOrganisms';

export function OrganismParam(props: Props<Parameter, State>) {
  if (!isOrganismParamProps(props)) {
    throw new Error(`Tried to render non-organism parameter ${props.parameter.name} with OrganismParam.`);
  }

  return (
    <div className="OrganismParam">
      <Suspense fallback={<Loading />}>
        <ValidatedOrganismParam {...props} />
      </Suspense>
    </div>
  );
}

export function ValidatedOrganismParam(props: Props<EnumParam, State>) {
  return props.parameter.displayType === 'treeBox'
    ? <TreeBoxOrganismEnumParam {...props as Props<TreeBoxEnumParam, State>} />
    : <ParamComponent {...props} />;
}

function TreeBoxOrganismEnumParam(props: Props<TreeBoxEnumParam, State>) {
  const selectedValues = useMemo(() => {
    return isMultiPick(props.parameter)
      ? toMultiValueArray(props.value)
      : props.value == null || props.value === ''
      ? []
      : [ props.value ];
  }, [ isMultiPick(props.parameter), props.value ]);

  const transformValue = useCallback((newValue: string[]) => {
    if (isMultiPick(props.parameter)) {
      return toMultiValueString(newValue);
    } else {
      return newValue.length === 0
        ? ''
        : newValue[0]
    }
  }, [ isMultiPick(props.parameter) ]);

  const onChange = useCallback((newValue: string[]) => {
    props.onParamValueChange(transformValue(newValue));
  }, [ props.onParamValueChange, transformValue ]);

  const paramWithPrunedVocab = useParamWithPrunedVocab(props.parameter, selectedValues, onChange);

  const referenceStrains = useReferenceStrains();

  const shouldHighlightReferenceOrganisms = props.parameter.properties?.[ORGANISM_PROPERTIES_KEY].includes(HIGHLIGHT_REFERENCE_ORGANISMS_PROPERTY) ?? false;

  const renderNode = useRenderOrganismNode(referenceStrains, shouldHighlightReferenceOrganisms);
  const searchPredicate = useOrganismSearchPredicate(referenceStrains, shouldHighlightReferenceOrganisms);

  const wrapCheckboxTreeProps = useCallback((props: CheckboxTreeProps<TreeBoxVocabNode>) => ({
    ...props,
    renderNode,
    searchPredicate
  }), [ renderNode, searchPredicate ]);

  return paramWithPrunedVocab.vocabulary.children.length === 0
    ? <p className="EmptyTree">
        This search applies only to organisms not in <strong>My Organisms</strong>.
        <br />
        To use this search, please first <Link to="/preferred-organisms">adjust My Organism Preferences</Link>.
      </p>
    : <TreeBoxEnumParamComponent
        {...props}
        selectedValues={selectedValues}
        onChange={onChange}
        context={props.ctx}
        parameter={paramWithPrunedVocab}
        wrapCheckboxTreeProps={wrapCheckboxTreeProps}
      />;
}

function useParamWithPrunedVocab(parameter: TreeBoxEnumParam, selectedValues: string[], onChange: (newValue: string[]) => void) {
  const initialSelectedValues = useRef(selectedValues);

  const [ preferredOrganisms ] = usePreferredOrganismsState();

  const { pathname } = useLocation();
  const isSearchPage = pathname.startsWith('/search');

  const preferredValues = useMemo(
    () => isSearchPage
      ? new Set(preferredOrganisms)
      : new Set([...initialSelectedValues.current, ...preferredOrganisms]),
    [ isSearchPage, preferredOrganisms ]
  );

  useEffect(() => {
    const filteredInitialSelectedValues = initialSelectedValues.current.filter(selectedValue => preferredValues.has(selectedValue));

    if (filteredInitialSelectedValues.length !== initialSelectedValues.current.length) {
      onChange(filteredInitialSelectedValues);
    }
  }, []);

  return useMemo(
    () => {
      const shouldPruneNodesWithSingleExtendingChild = parameter.properties?.[ORGANISM_PROPERTIES_KEY].includes(PRUNE_NODES_WITH_SINGLE_EXTENDING_CHILD_PROPERTY);

      const prunedVocabulary = shouldPruneNodesWithSingleExtendingChild
        ? pruneNodesWithSingleExtendingChild(parameter.vocabulary)
        : parameter.vocabulary;

      const shouldOnlyShowPreferredOrganisms = parameter.properties?.[ORGANISM_PROPERTIES_KEY].includes(SHOW_ONLY_PREFERRED_ORGANISMS_PROPERTY);

      const preferredVocabulary = shouldOnlyShowPreferredOrganisms
        ? pruneDescendantNodes(
            node => (
              node.children.length > 0 ||
              preferredValues.has(node.data.term)
            ),
            prunedVocabulary
          )
        : prunedVocabulary;

      return parameter.vocabulary === preferredVocabulary
        ? parameter
        : {
            ...parameter,
            vocabulary: preferredVocabulary
          };
    },
    [ isSearchPage, parameter, preferredValues ]
  );
}

function isOrganismParamProps<S = void>(props: Props<Parameter, S>): props is Props<EnumParam, S> {
  return isPropsType(props, isOrganismParam);
}

export function isOrganismParam(parameter: Parameter): parameter is EnumParam {
  return (
    parameter?.properties?.[ORGANISM_PROPERTIES_KEY] != null &&
    EnumParamModule.isType(parameter)
  );
}
