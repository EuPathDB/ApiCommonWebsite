import React, { useEffect, useMemo, useState } from 'react';
import { keyBy } from 'lodash';

import { Loading, IconAlt } from 'wdk-client/Components';

import { makeVpdbClassNameHelper, useCommunitySiteUrl } from './Utils';

import { combineClassNames } from 'ebrc-client/components/homepage/Utils';
import { useSessionBackedState } from 'wdk-client/Hooks/SessionBackedState';
import { decode, string } from 'wdk-client/Utils/Json';

import './FeaturedTools.scss';

const cx = makeVpdbClassNameHelper('FeaturedTools');
const bgDarkCx = makeVpdbClassNameHelper('BgDark');

const FEATURED_TOOL_URL_SEGMENT = 'json/features_tools.json';

type FeaturedToolResponseData = FeaturedToolEntry[];

type FeaturedToolMetadata = {
  toolListOrder: string[],
  toolEntries: Record<string, FeaturedToolEntry>
};

type FeaturedToolEntry = {
  identifier: string,
  listIconKey: string,
  listTitle: string,
  descriptionTitle?: string,
  output: string
};

function useFeaturedToolMetadata(): FeaturedToolMetadata | undefined {
  const communitySiteUrl = useCommunitySiteUrl();
  const [ featuredToolResponseData, setFeaturedToolResponseData ] = useState<FeaturedToolResponseData | undefined>(undefined);

  useEffect(() => {
    if (communitySiteUrl != null) {
      (async () => {
        // FIXME Add basic error-handling 
        const response = await fetch(`${communitySiteUrl}${FEATURED_TOOL_URL_SEGMENT}`, { mode: 'cors' });

        // FIXME Validate this JSON using a Decoder
        const responseData = await response.json() as FeaturedToolResponseData;

        setFeaturedToolResponseData(responseData);
      })();
    }
  }, [ communitySiteUrl ]);

  const featuredToolMetadata = useMemo(
    () => 
      featuredToolResponseData && 
      {
        toolListOrder: featuredToolResponseData.map(({ identifier }) => identifier),
        toolEntries: keyBy(featuredToolResponseData, 'identifier')
      }, 
    [ featuredToolResponseData ]
  );

  return featuredToolMetadata;
}

const FEATURED_TOOL_KEY = 'homepage-featured-tool';

export const FeaturedTools = () => {
  const toolMetadata = useFeaturedToolMetadata();
  const [ selectedTool, setSelectedTool ] = useSessionBackedState<string | undefined>(
    undefined,
    FEATURED_TOOL_KEY,
    JSON.stringify,
    (s: string) => decode(string, s)
  );
  const selectedToolEntry = !toolMetadata || !selectedTool || !toolMetadata.toolEntries[selectedTool]
    ? undefined
    : toolMetadata.toolEntries[selectedTool];

  useEffect(() => {
    if (
      toolMetadata && 
      toolMetadata.toolListOrder.length > 0 && 
      toolMetadata.toolEntries[toolMetadata.toolListOrder[0]] &&
      (!selectedTool || !toolMetadata.toolEntries[selectedTool])
    ) {
      setSelectedTool(toolMetadata.toolListOrder[0]);
    }
  }, [ toolMetadata ]);

  return (
    <div className={cx()}>
      <div className={cx('Header')}>
        <h3>Featured Resources and Tools</h3>
        <a href="">View all resources &amp; tools <IconAlt fa="angle-double-right" /></a>
      </div>
      {
        !toolMetadata 
          ? <Loading />
          : <div className={cx('List')}>          
              <FeaturedToolList
                toolMetadata={toolMetadata}
                setSelectedTool={setSelectedTool}
                selectedTool={selectedTool}
              />
              <SelectedTool
                entry={selectedToolEntry}
              />
            </div>
      }
    </div>
  );
}

type FeaturedToolListProps = {
  toolMetadata: FeaturedToolMetadata;
  selectedTool?: string;
  setSelectedTool: (nextSelectedTool: string) => void;
};

const FeaturedToolList = ({
  toolMetadata: { toolEntries, toolListOrder },
  selectedTool,
  setSelectedTool
}: FeaturedToolListProps) => 
  <div className={cx('ListItems')}>
    {toolListOrder
      .filter(toolKey => toolEntries[toolKey])
      .map(toolKey => (
        <ToolListItem
          key={toolKey}
          entry={toolEntries[toolKey]}
          isSelected={toolKey === selectedTool}
          onSelect={() => {
            setSelectedTool(toolKey);
          }}
        />
      ))}
  </div>;

type ToolListItemProps = {
  entry: FeaturedToolEntry;
  isSelected: boolean;
  onSelect: () => void;
};

const ToolListItem = ({ entry, onSelect, isSelected }: ToolListItemProps) =>
  <a
    className={cx('ListItem', isSelected && 'selected')}
    href="#"
    onClick={e => {
      e.preventDefault();
      onSelect(); 
    }}
    type="button"
  >
    <IconAlt fa={entry.listIconKey} />
    {entry.listTitle}
  </a>;

type SelectedToolProps = {
  entry?: FeaturedToolEntry
};

const SelectedTool = ({ entry }: SelectedToolProps) => 
  <div className={cx('Selection')}>
    {
      entry && entry.descriptionTitle &&
      <h5 className={combineClassNames(cx('SelectionHeader'), bgDarkCx())}>
        {entry.descriptionTitle}
      </h5>
    }
    <div
      className={cx('SelectionBody')}
      dangerouslySetInnerHTML={{
        __html: entry ? entry.output : '...'
      }}
    ></div>
  </div>;
