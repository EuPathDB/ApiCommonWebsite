import React, { useCallback, useEffect, useMemo, useState } from 'react';
import Select from 'react-select';
import { ValueType, InputActionMeta } from 'react-select/src/types';
import { Option } from 'react-select/src/filters';

import { NodeCollection } from 'cytoscape';
import { isEqual, orderBy, uniqWith } from 'lodash';

import { safeHtml } from 'wdk-client/Utils/ComponentUtils';
import { stripHTML } from 'wdk-client/Views/Records/RecordUtils';

import { NodeSearchCriteria } from './pathway-utils';

interface Props {
  nodes: NodeCollection;
  onSearchCriteriaChange: (searchCriteria: NodeSearchCriteria | undefined) => void;
}

interface NodeOptionDatum {
  name: string | undefined;
  node_identifier: string | undefined;
};

export function PathwaySearchById({ nodes, onSearchCriteriaChange }: Props) {
  const [ searchTerm, setSearchTerm ] = useState('');

  const options = useMemo(
    () => {
      const identifiableNodes = nodes.toArray().filter(
        node => node.data('node_identifier') != null || node.data('name') != null
      );

      const nodeOptionData: NodeOptionDatum[] = identifiableNodes.map(node => ({
        name: typeof node.data('name') === 'string'
          ? node.data('name')
          : undefined,
        node_identifier: typeof node.data('node_identifier') === 'string'
          ? node.data('node_identifier')
          : undefined
      }));

      const uniqueNodeOptionData = uniqWith(nodeOptionData, isEqual);

      const uniqueNodeOptions = uniqueNodeOptionData.map(({ node_identifier, name }) => ({
        value: `${node_identifier || ''}\0${name || ''}`,
        label: name != null && node_identifier != null
          ? `${node_identifier} (${name})`
          : node_identifier ?? name ?? '',
        data: null
      }));

      return orderBy(
        uniqueNodeOptions,
        nodeOption => nodeOption.label
      );
    },
    [ nodes ]
  );

  const [ selection, setSelection ] = useState([] as Option[]);

  const onChange = useCallback((newSelection: ValueType<Option>) => {
    const newSelectionArray = newSelection == null
      ? []
      : Array.isArray(newSelection)
      ? (newSelection as Option[])
      : [newSelection as Option];

    setSelection(newSelectionArray);
    setSearchTerm('');
  }, []);

  const onInputChange = useCallback((inputValue: string, { action }: InputActionMeta) => {
    if (action === 'input-change') {
      setSearchTerm(inputValue);
    }
  }, []);

  const filterOption = useCallback((option: Option, newSearchTerm: string) => {
    const normalizedInputValue = newSearchTerm.toLowerCase();

    const normalizedOptionValue = stripHTML(option.value).toLowerCase();

    return normalizedOptionValue.includes(normalizedInputValue);
  }, []);

  const noOptionsMessage = useCallback(
    () => 'No identifiers match your search term',
    []
  );

  const formatOptionLabel = useCallback(
    (option: Option) => safeHtml(option.label),
    []
  );

  useEffect(() => {
    if (selection.length === 0) {
      onSearchCriteriaChange(undefined);
    } else {
      const newSearchCriteria = selection.map(item => {
        const [ node_identifier, name ] = item.value.split('\0');

        const nodeIdentifierSelector = node_identifier.length > 0
          ? `[node_identifier = '${node_identifier}']`
          : '';

        const nameSelector = name.length > 0
          ? `[name = '${name}']`
          : '';

        return `node${nodeIdentifierSelector}${nameSelector}`;
      });

      onSearchCriteriaChange(newSearchCriteria.join(', '));
    }
  }, [ selection ]);

  return (
    <div className="veupathdb-PathwaySearchById">
      <Select
        autoFocus
        isMulti
        isSearchable
        options={options}
        filterOption={filterOption}
        noOptionsMessage={noOptionsMessage}
        value={selection}
        onChange={onChange}
        inputValue={searchTerm}
        onInputChange={onInputChange}
        placeholder="Select identifiers"
        formatOptionLabel={formatOptionLabel}
      />
    </div>
  );
}
