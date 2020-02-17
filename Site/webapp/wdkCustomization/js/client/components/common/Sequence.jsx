import { orderBy, range } from 'lodash';
import React from 'react';
import { useRef, useState } from 'react';
import PropTypes from 'prop-types';

import { useIsRefOverflowingVertically } from 'wdk-client/Hooks/Overflow';

const NUM_COLS = 80;

function Sequence(props) {
  const { highlightRegions, sequence } = props;
  const ref = useRef(null);
  const [ isExpanded, setIsExpanded ] = useState(false);
  const isOverflowing = useIsRefOverflowingVertically(ref);

  const style = {
    width: `${NUM_COLS}ch`,
    whiteSpace: 'break-spaces',
    wordBreak: 'break-all',
    maxHeight: isExpanded ? '' : '30vh',
    overflow: 'hidden'
  };

  const sortedHilightRegions = orderBy(highlightRegions, ['start']);
  const firstHighlightRegion = sortedHilightRegions[0];
  // array of react elements
  const highlightedSequence = firstHighlightRegion == null ? [ <React.Fragment>{sequence}</React.Fragment> ]
    : firstHighlightRegion.start === 0 ? []
    : [sequence.slice(0, firstHighlightRegion.start - 1)];

  for (let index = 0; index < sortedHilightRegions.length; index++) {
    const region = highlightRegions[index];
    const nextRegion = highlightRegions[index + 1];
    highlightedSequence.push(region.renderRegion(sequence.slice(region.start - 1, region.end)));
    highlightedSequence.push(sequence.slice(region.end, nextRegion == null ? sequence.length : nextRegion.start - 1));
  }

  // FIXME Trunate and show "Show more" button
  return (
    <div style={{ position: 'relative' }}>
      <pre ref={ref} onCopy={handleCopy} style={style}>
        {highlightedSequence}
      </pre>
      {isOverflowing && (
        <div style={isExpanded ? {
          fontWeight: 500
        } : {
          position: 'absolute',
          bottom: 0,
          width: '100%',
          paddingTop: '2em',
          background: 'linear-gradient(to bottom, transparent, white 50%)',
          fontWeight: 500
        }}>
          <button type="button" className="link" onClick={() => setIsExpanded(!isExpanded)}>
            <i className={`fa fa-chevron-${isExpanded ? 'up' : 'down'}`}/> {isExpanded ? 'Show less' : 'Show more'}
          </button>
        </div>
      )}
    </div>
  );
}

Sequence.propTypes = {
  /** The sequence to display **/
  sequence: PropTypes.string.isRequired,

  /** Regions to highlight, using 1-based indexing for start and end **/
  highlightRegions: PropTypes.arrayOf(PropTypes.shape({
    renderRegion: PropTypes.func.isRequired,
    start: PropTypes.number.isRequired,
    end: PropTypes.number.isRequired
  }))
};

Sequence.defaultProps = {
  highlightRegions: []
};

function handleCopy(event) {
  const string = window.getSelection().toString();
  const selection = range(Math.ceil(string.length / NUM_COLS))
    .map(n => string.slice(n * NUM_COLS, n * NUM_COLS + NUM_COLS))
    .join('\n');
  event.clipboardData.setData('text/plain', selection);
  event.preventDefault();
}

export default Sequence;
