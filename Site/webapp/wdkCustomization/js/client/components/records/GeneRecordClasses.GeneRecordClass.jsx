/* global wdk */
import React from 'react';
import ReactDOM from 'react-dom';
import lodash from 'lodash';
import {NativeCheckboxList, RecordLink, Sticky} from 'wdk-client/Components';
import {renderAttributeValue} from 'wdk-client/ComponentUtils';
import {getPropertyValue, getTree} from 'wdk-client/OntologyUtils';
import ExpressionGraph from '../common/ExpressionGraph';
import Sequence from '../common/Sequence';
import * as Thumbnails from '../common/OverviewThumbnails';
import * as Gbrowse from '../common/Gbrowse';
import {getBestPosition, isNodeOverflowing} from '../../utils';

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
    let { attributes, tables } = this.props.record;
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
    }))
    .concat({
      displayName: 'Transcriptomics',
      imgUrl: wdk.assetsUrl('wdkCustomization/images/transcriptomics.jpg'),
      anchor: 'ExpressionGraphs',
      data: {
        count: tables && tables.ExpressionGraphs && tables.ExpressionGraphs.length
      }
    });

    let thumbsContainer = this.node.querySelector('.eupathdb-ThumbnailsContainer');

    if (thumbsContainer == null) {
      console.error('Warning: Could not find ThumbnailsContainer');
    }
    else {
      ReactDOM.render((
        <Thumbnails.OverviewThumbnails  thumbnails={filteredGBrowseContexts}/>
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
  return expressionRE.test(props.table.name)              ? <ExpressionGraphTable {...props} />
       : props.table.name === 'MercatorTable'             ? <MercatorTable {...props} />
       : props.table.name === 'ProteinProperties'         ? <ProteinPbrowseTable {...props} />
       : props.table.name === 'ProteinExpressionPBrowse'  ? <ProteinPbrowseTable {...props} />
       : props.table.name === 'Sequences'                 ? <SequencesTable {...props} />
       : props.table.name === 'UserComments'              ? (
         <div>
           <p>
             <a href={props.record.attributes.user_comment_link_url}>
               Add a comment <i className="fa fa-comment"/>
             </a>
           </p>
           <props.DefaultComponent {...props} />
         </div>
       )
       : <props.DefaultComponent {...props} />
}

function OverviewItem(props) {
    let { label, value = 'undefined' } = props;
    return value == null ? <noscript/> : (
        <div className="GeneOverviewItem"><label>{label}</label> {ComponentUtils.renderAttributeValue(value)}</div>
    );
}

function ExpressionGraphTable(props) {
    let included = props.table.properties.includeInTable || [];

    let dataTable;

    if(props.table.name == "HostResponseGraphs") {
        // TODO
    }
    else {
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
