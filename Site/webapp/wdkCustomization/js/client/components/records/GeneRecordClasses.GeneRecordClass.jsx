import React from 'react';
import ReactDOM from 'react-dom';
import lodash from 'lodash';
import {
  Components,
  ComponentUtils,
  OntologyUtils,
  TreeUtils
} from 'wdk-client';
import ExpressionGraph from '../common/ExpressionGraph';
import Sequence from '../common/Sequence';
import * as Gbrowse from '../common/Gbrowse';
import { getBestPosition, isNodeOverflowing } from '../../utils';


let {
  NativeCheckboxList,
  RecordLink,
  Sticky
} = Components;

export const GENE_ID = 'gene';
export const TRANSCRIPT_ID = 'transcript';
export const TRANSCRIPT_ID_KEY_PREFIX = 'eupathdb::previousTranscriptId::';
export const RECORD_CLASS_NAME = 'GeneRecordClasses.GeneRecordClass';

function scrollToElementById(id) {
  let el = document.getElementById(id);
  if (el == undefined) return;
  let rect = el.getBoundingClientRect();
  if (rect.top < 0) return;
  el.scrollIntoView();
}

// Clone ontology tree, adding a prefix to the label property
function prefixLabel(prefix, root) {
  return Object.assign({}, root, {
    properties: Object.assign({}, root.properties, {
      label: [ prefix + '-' + OntologyUtils.getPropertyValue('label', root) ]
    }),
    children: root.children.map(child => prefixLabel(prefix, child)),
    __original: root
  });
}

// For use on the Transcript Record page.
// This will load the target transcript without calling the router, thus
// keeping the URL the same.
function TranscriptLink(props, context) {
  let { onClick = () => {} } = props;
  let geneId = props.recordId.find(p => p.name === 'gene_source_id').value;
  let transcriptId = props.recordId.find(p => p.name === 'source_id').value;
  return (
    <a
      {...props}
      href={'./geneId'}
      onClick={(event) => {
        event.preventDefault();
        // store the last requested transcript id for the gene id
        window.sessionStorage.setItem(TRANSCRIPT_ID_KEY_PREFIX + geneId, transcriptId);
        context.actionCreators.RecordViewActionCreator.fetchRecordDetails(
          props.recordClass.urlSegment,
          props.recordId.map(p => p.value)
        );
        onClick(event);
      }}
    >
      {props.children}
    </a>
  );
}
TranscriptLink.contextTypes = {
  actionCreators: React.PropTypes.object
};

/**
 * Create a new record ID based on an existing ID.
 *
 * @param {Array<Object>} oldId
 * @param {Object} newParts New ID values
 */
function makeRecordId(oldId, newParts) {
  return oldId.map(idPart => {
    return Object.assign({}, idPart, {
      value: newParts[idPart.name] || idPart.value
    });
  });
}

function TranscriptList(props, context) {
  let { record, recordClass } = props;
  let params = { class: recordClass.name };
    if (record.tables.GeneTranscripts == null) return null;

    return (
        <div className="eupathdb-TranscriptListContainer">
            <ul className="eupathdb-TranscriptRecordNavList">
                {record.tables.GeneTranscripts.map(row => {
                     let { transcript_id } = row;
                     let recordId = makeRecordId(record.id, {
                         source_id: transcript_id
                     });
                     let active = record.id.find(p => p.name === 'source_id').value === transcript_id;
                     return (
                         <li key={transcript_id}>
                             <TranscriptLink
                                 className={active ? 'active' : ''}
                                 recordId={recordId}
                                 recordClass={recordClass}
                                 onClick={() => {
                                         scrollToElementById(TRANSCRIPT_ID);
                                     }}
                             >
                                 {transcript_id}
                             </TranscriptLink>
                         </li>
                     );
                 })}
            </ul>
        </div>
    );
}

/**
 * Render thumbnails at eupathdb-GeneThumbnailsContainer
 */
export class RecordOverview extends React.Component {

    componentDidMount() {
        this.renderThumbnails();
    }

    componentDidUpdate() {
        this.renderThumbnails();
    }

    renderThumbnails() {
        let { recordClass } = this.props;
        let { attributes } = this.props.record;
        let { gene_type, protein_expression_gtracks } = attributes;
        let isProteinCoding = gene_type === 'protein coding';
        let filteredGBrowseContexts = Gbrowse.contexts.filter(context => {
            return context.gbrowse_url in attributes && (
                !context.isPbrowse || (isProteinCoding && context.gbrowse_url !== 'ProteomicsPbrowseUrl') ||
                (isProteinCoding && context.gbrowse_url === 'ProteomicsPbrowseUrl' && protein_expression_gtracks)
            );
        })
                                             .map(thumbnail => Object.assign({}, thumbnail, {
                                                 imgUrl: attributes[thumbnail.gbrowse_url],
                                                 displayName: recordClass.attributesMap.get(thumbnail.gbrowse_url).displayName
                                             }));
        let thumbsContainer = this.node.querySelector('.eupathdb-GeneThumbnailsContainer');
        if (thumbsContainer == null) {
            console.error('Warning: Could not find GeneThumbnailsContainer');
        }
        else {
            ReactDOM.render((
                <OverviewThumbnails thumbnails={filteredGBrowseContexts}/>
            ), thumbsContainer);
        }
    }

    render() {
        let { DefaultComponent } = this.props;
        return (
            <div ref={node => this.node = node}>
                <DefaultComponent {...this.props}/>
            </div>
        );
    }

}

let expressionRE = /ExpressionGraphs|HostResponseGraphs|PhenotypeGraphs$/;
export function RecordTable(props) {
    let Table = props.DefaultComponent;

    if (expressionRE.test(props.table.name)) {
        Table = ExpressionGraphTable;
    }
    if (props.table.name === 'MercatorTable') {
        Table = MercatorTable;
    }
    if (props.table.name === 'ProteinProperties') {
        Table = ProteinPbrowseTable;
    }
    if (props.table.name === 'ProteinExpressionPBrowse') {
        Table = ProteinPbrowseTable;
    }
    if (props.table.name === 'Sequences') {
        Table = SequencesTable;
    }

    return <Table {...props}/>
}

function OverviewItem(props) {
    let { label, value = 'undefined' } = props;
    return value == null ? <noscript/> : (
        <div className="GeneOverviewItem"><label>{label}</label> {ComponentUtils.renderAttributeValue(value)}</div>
    );
}

// TODO Smart position of popover
class OverviewThumbnails extends React.Component {

    constructor(...args) {
        super(...args);
        this.timeoutId = null;
        this.state = {
            showPopover: false
        };

        this.setNode = node => { this.node = node; };

        this.computePosition = popoverNode => {
            if (popoverNode == null) return;
            let { offsetLeft, offsetTop } = getBestPosition(
                popoverNode,
                this.state.activeThumbnailNode
            );
            popoverNode.style.left = offsetLeft + 'px';
            popoverNode.style.top = offsetTop + 'px';
        };

        this.detectOverflow = lodash.throttle(() => {
            console.log('is overflowed', isNodeOverflowing(this.node));
        }, 250);

        this.handleThumbnailMouseEnter = thumbnail => event => {
            this.setShowPopover(true, 250);
            this.setActiveThumbnail(event, thumbnail);
        };

        this.handlePopoverMouseEnter = () => {
            this.setShowPopover(true, 250);
        };

        this.handleThumbnailMouseLeave = this.handlePopoverMouseLeave = () => {
            this.setShowPopover(false, 250);
        };

        this.handlePopoverClick = () => {
            this.setShowPopover(false, 0);
        };
    }

    componentDidMount() {
        window.addEventListener('resize', this.detectOverflow);
    }

    componentWillUnmount() {
        window.removeEventListener('resize', this.detectOverflow);
    }

    setActiveThumbnail(event, thumbnail) {
        if (thumbnail === this.state.activeThumbnail) return;
        this.setState({
            activeThumbnail: thumbnail,
            activeThumbnailNode: event.target,
            showPopover: false
        });
    }

    setShowPopover(show, delay) {
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(() => {
            this.setState({ showPopover: show });
        }, delay);
    }

    render() {
        return (
            <div ref={this.setNode} className="eupathdb-GeneThumbnails">
                {this.props.thumbnails.map(thumbnail => (
                     <div className="eupathdb-GeneThumbnailWrapper" key={thumbnail.gbrowse_url}>
                         <div className="eupathdb-GeneThumbnailLabel">
                             <a href={'#' + thumbnail.anchor}>{thumbnail.displayName}</a>
                         </div>
                         <div className="eupathdb-GeneThumbnail"
                              onMouseEnter={this.handleThumbnailMouseEnter(thumbnail)}
                              onMouseLeave={this.handleThumbnailMouseLeave}>
                             <a href={'#' + thumbnail.anchor}>
                                 <img width="150" src={thumbnail.imgUrl}/>
                             </a>
                         </div>
                     </div>
                 ))}
                     {this.renderPopover()}
            </div>
        );
    }

    renderPopover() {
        if (this.state.showPopover) {
            return (
                <div className="eupathdb-GeneThumbnailPopover"
                     ref={this.computePosition}
                     onMouseEnter={this.handlePopoverMouseEnter}
                     onMouseLeave={this.handlePopoverMouseLeave}>
                    <h3>{this.state.activeThumbnail.displayName}</h3>
                    <div>(Click on image to view section on page)</div>
                    <a href={'#' + this.state.activeThumbnail.anchor}
                       onClick={this.handlePopoverClick}>
                        <img src={this.state.activeThumbnail.imgUrl}/>
                    </a>
                </div>
            );
        }
    }

}

let treeCache = new WeakMap;
function extractGeneAndTranscriptTrees(categories) {
    if (!treeCache.has(categories)) {
        let fakeOntology = { tree: { children: categories } };
        let geneRoot = prefixLabel(GENE_ID, OntologyUtils.getTree(
            fakeOntology,
            node => lodash.get(node, 'properties.geneOrTranscript[0]') === GENE_ID
        ));

        let transcriptRoot = prefixLabel(TRANSCRIPT_ID, OntologyUtils.getTree(
            fakeOntology,
            node => lodash.get(node, 'properties.geneOrTranscript[0]') === TRANSCRIPT_ID
        ));

        treeCache.set(categories, { geneRoot, transcriptRoot });
    }
    return treeCache.get(categories);
}

export function RecordNavigationSectionCategories(props) {
    let { categories } = props;
    let { geneRoot, transcriptRoot } = extractGeneAndTranscriptTrees(categories);
    return (
        <div className="eupathdb-TranscriptRecordNavigationSectionContainer">
            <h3>Gene</h3>
            <props.DefaultComponent
        {...props}
        isVisible={node => props.isVisible(node.__original)}
        categories={geneRoot.children}
            />
            <h3>Transcript</h3>
            <TranscriptList {...props}/>
            <props.DefaultComponent
        {...props}
        isVisible={node => props.isVisible(node.__original)}
        categories={transcriptRoot.children}
            />
        </div>
    );
}

export function RecordMainSection(props) {
    let { recordClass, record } = props;
    return (
        <div>
            <Sticky className="eupathdb-TranscriptSticky" fixedClassName="eupathdb-TranscriptSticky-fixed">
                {/*  <h2 className="eupathdb-TranscriptHeading">Transcript</h2> */ }
                <nav className="eupathdb-TranscriptTabList">
                    {props.record.tables.GeneTranscripts.map(row => {
                         let { transcript_id } = row;
                         let recordId = makeRecordId(record.id, {
                             source_id: transcript_id
                         });
                         let active = record.id.find(p => p.name === 'source_id').value === transcript_id;
                         let className = [
                             'eupathdb-TranscriptLink',
                             active ? 'eupathdb-TranscriptLink-active active': ''
                         ].join(' ');
                         return (
                             <TranscriptLink
                                 key={transcript_id}
                                 recordId={recordId}
                                 recordClass={recordClass}
                                 className={className}
                             >
                                 {transcript_id}
                             </TranscriptLink>
                         );
                     })}
                </nav>
            </Sticky>
            <div className="eupathdb-TranscriptTabContent">
                <props.DefaultComponent {...props} />
            </div>
        </div>
    );
}

/*
   export let RecordMainSection = React.createClass({

   render() {
   let { categories } = this.props;
   let { geneRoot, transcriptRoot } = extractGeneAndTranscriptTrees(categories);

   let uncategorized = categories.find(c => c.name === undefined);
   categories = categories.filter(c => c !== uncategorized);
   return(
   <div>
   {this.renderGeneCategory(geneRoot)}
   {this.renderTransCategory(transcriptRoot)}
   </div>
   );
   },

   renderGeneCategory(category) {
   return (
   <section id={GENE_ID}>
   <this.props.DefaultComponent {...this.props} categories={category.children}/>
   </section>
   );
   },

   renderTransCategory(category) {
   let { recordClass, record, collapsedCategories } = this.props;
   let allCategoriesHidden = category.children.every(cat => collapsedCategories.includes(cat.name));
   return (
   <section id={TRANSCRIPT_ID}>
   <Sticky className="eupathdb-TranscriptSticky" fixedClassName="eupathdb-TranscriptSticky-fixed">
   <h1 className="eupathdb-TranscriptHeading">Transcript</h1>
   <nav className="eupathdb-TranscriptTabList">
   {this.props.record.tables.GeneTranscripts.map(row => {
   let { transcript_id } = row;
   let recordId = makeRecordId(record.id, {
   source_id: transcript_id
   });
   let active = record.id.find(p => p.name === 'source_id').value === transcript_id;
   let className = [
   'eupathdb-TranscriptLink',
   active ? 'eupathdb-TranscriptLink-active active': ''
   ].join(' ');
   return (
   <TranscriptLink
   key={transcript_id}
   recordId={recordId}
   recordClass={recordClass}
   className={className}
   >
   {transcript_id}
   </TranscriptLink>
   );
   })}
   </nav>
   </Sticky>
   <div className="eupathdb-TranscriptTabContent">
   {allCategoriesHidden
   ? <p>All Transcript categories are currently hidden.</p>
   :  <this.props.DefaultComponent {...this.props} categories={category.children}/>}
   </div>
   </section>
   );
   }

   });
 */

function ExpressionGraphTable(props) {
    let included = props.table.properties.includeInTable || [];



    let dataTable;

    if(props.table.name == "ExpressionGraphs") {
        dataTable = Object.assign({}, {
            value: props.record.tables.ExpressionGraphsDataTable,
            table: props.recordClass.tables.find(obj => obj.name == "ExpressionGraphsDataTable"),
            record: props.record,
            recordClass: props.recordClass,
            DefaultComponent: props.DefaultComponent
                }
        );

    }


    let table = Object.assign({}, props.table, {
        attributes: props.table.attributes.filter(tm => included.indexOf(tm.name) > -1)
    });


    return (
        <props.DefaultComponent
      {...props}
      table={table}
      childRow={childProps =>
          <ExpressionGraph  rowData={props.value[childProps.rowIndex]} dataTable={dataTable}  />}
      />
  );
}

function ProteinPbrowseTable(props) {
  let included = props.table.properties.includeInTable || [];

  let table = Object.assign({}, props.table, {
    attributes: props.table.attributes.filter(tm => included.indexOf(tm.name) > -1)
  });

  return (
    <props.DefaultComponent
      {...props}
      table={table}
      childRow={childProps =>
        <Gbrowse.ProteinContext {...props} rowData={props.value[childProps.rowIndex]}/>}
    />
  );
}


function SequencesTable(props) {
  let included = props.table.properties.includeInTable || [];
  let table = Object.assign({}, props.table, {
    attributes: props.table.attributes.filter(tm => included.indexOf(tm.name) > -1)
  });

  return (
    <props.DefaultComponent
      {...props}
      table={table}
      childRow={childProps => {
        let utrClassName = 'eupathdb-UtrSequenceNucleotide';
        let intronClassName = 'eupathdb-IntronSequenceNucleotide';

        let {
          protein_sequence,
          transcript_sequence,
          genomic_sequence,
          protein_length,
          transcript_length,
          genomic_sequence_length,
          five_prime_utr_coords,
          three_prime_utr_coords,
          gen_rel_intron_utr_coords
        } = childProps.rowData;

        let transcriptRegions = [
          JSON.parse(five_prime_utr_coords) || undefined,
          JSON.parse(three_prime_utr_coords) || undefined
        ].filter(coords => coords != null)

        let transcriptHighlightRegions = transcriptRegions.map(coords => {
          return { className: utrClassName, start: coords[0], end: coords[1] };
        });

        let genomicRegions = JSON.parse(gen_rel_intron_utr_coords || '[]');

        let genomicHighlightRegions = genomicRegions.map(coord => {
          return {
            className: coord[0] === 'Intron' ? intronClassName : utrClassName,
            start: coord[1],
            end: coord[2]
          };
        });

        let genomicRegionTypes = lodash(genomicRegions)
        .map(region => region[0])
        .sortBy()
        .uniq(true)
        .value();

        let legendStyle = { marginRight: '1em', textDecoration: 'underline' };
        return (
          <div>
            {protein_sequence == null ? null : (
              <div style={{ padding: '1em' }}>
                <h3>Predicted Protein Sequence</h3>
                <div><span style={legendStyle}>{protein_length} bp</span></div>
                <Sequence sequence={protein_sequence}/>
              </div>
            )}

            {protein_sequence == null ? null : <hr/>}

            <div style={{ padding: '1em' }}>
              <h3>Predicted RNA/mRNA Sequence (Introns spliced out{ transcriptRegions.length > 0 ? '; UTRs highlighted' : null })</h3>
              <div>
                <span style={legendStyle}>{transcript_length} bp</span>
                { transcriptRegions.length > 0 ? <span style={legendStyle} className={utrClassName}>&nbsp;UTR&nbsp;</span> : null }
              </div>
              <Sequence sequence={transcript_sequence}
                highlightRegions={transcriptHighlightRegions}/>
            </div>

            <div style={{ padding: '1em' }}>
              <h3>Genomic Sequence { genomicRegionTypes.length > 0 ? ' (' + genomicRegionTypes.map(t => t + 's').join(' and ') + ' highlighted)' : null}</h3>
              <div>
                <span style={legendStyle}>{genomic_sequence_length} bp</span>
                {genomicRegionTypes.map(t => {
                  let className = t === 'Intron' ? intronClassName : utrClassName;
                  return (
                    <span style={legendStyle} className={className}>&nbsp;{t}&nbsp;</span>
                  );
                })}
              </div>
              <Sequence sequence={genomic_sequence}
                highlightRegions={genomicHighlightRegions}/>
            </div>

          </div>
        );
      }}
    />
  );
}



function MercatorTable(props) {
  return (
    <div className="eupathdb-MercatorTable">
      <form action="/cgi-bin/pairwiseMercator">
        <input type="hidden" name="project_id" value={wdk.MODEL_NAME}/>

        <div className="form-group">
          <label><strong>Contig ID:</strong> <input name="contig" defaultValue={props.record.attributes.sequence_id}/></label>
        </div>

        <div className="form-group">
          <label>
            <strong>Nucleotide positions: </strong>
            <input
              name="start"
              defaultValue={props.record.attributes.start_min}
              maxLength="10"
              size="10"
            />
          </label>
          <label> to <input
              name="stop"
              defaultValue={props.record.attributes.end_max}
              maxLength="10"
              size="10"
            />
          </label>
          <label> <input name="revComp" type="checkbox" defaultChecked={true}/> Reverse & compliment </label>
        </div>

        <div className="form-group">
          <strong>Genomes to align:</strong>
          <NativeCheckboxList
            name="genomes"
            items={props.value.map(row => ({
              value: row.abbrev,
              display: row.organism
            }))}
          />
        </div>

        <div className="form-group">
          <strong>Select output:</strong>
          <div className="form-radio"><label><input name="type" type="radio" value="clustal" defaultChecked={true}/> Multiple sequence alignment (clustal)</label></div>
          <div className="form-radio"><label><input name="type" type="radio" value="fasta_ungapped"/> Multi-FASTA</label></div>
        </div>

        <input type="submit"/>
      </form>
    </div>
  );
}
