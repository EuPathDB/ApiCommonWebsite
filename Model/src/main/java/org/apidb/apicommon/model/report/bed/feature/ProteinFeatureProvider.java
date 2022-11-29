package org.apidb.apicommon.model.report.bed.feature;

import java.util.List;

import org.apidb.apicommon.model.TranscriptUtil;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.record.RecordInstance;
import org.json.JSONObject;
import org.apidb.apicommon.model.report.bed.util.StrandDirection;
import org.apidb.apicommon.model.report.bed.util.RequestedDeflineFields;
import org.apidb.apicommon.model.report.bed.util.DeflineBuilder;
import org.apidb.apicommon.model.report.bed.util.BedLine;

public class ProteinFeatureProvider implements BedFeatureProvider {

  private static final String ATTR_PROTEIN_LENGTH = "protein_length";
  private static final String ATTR_ORGANISM = "organism";
  private static final String ATTR_GENE_PRODUCT = "gene_product";

  private final RequestedDeflineFields _requestedDeflineFields;
  private final int _startOffset;
  private final Anchor _startAnchor;
  private final int _endOffset;
  private final Anchor _endAnchor;

  public ProteinFeatureProvider(JSONObject config) {
    _requestedDeflineFields = new RequestedDeflineFields(config);

    _startOffset = config.getInt("startOffset3");
    _startAnchor = Anchor.valueOf(config.getString("startAnchor3"));

    _endOffset = config.getInt("endOffset3");
    _endAnchor = Anchor.valueOf(config.getString("endAnchor3"));
  }

  @Override
  public String getRequiredRecordClassFullName() {
    return TranscriptUtil.TRANSCRIPT_RECORDCLASS;
  }

  @Override
  public String[] getRequiredAttributeNames() {
    return new String[] {
        ATTR_PROTEIN_LENGTH,
        ATTR_ORGANISM,
        ATTR_GENE_PRODUCT
    };
  }

  @Override
  public String[] getRequiredTableNames() {
    return new String[0];
  }

  @Override
  public List<List<String>> getRecordAsBedFields(RecordInstance record) throws WdkModelException {
    String featureId = getSourceId(record);
    String chrom = featureId;
    Integer featureLength = Integer.valueOf(stringValue(record, ATTR_PROTEIN_LENGTH));
    StrandDirection strand = StrandDirection.none;

    Integer segmentStart = getPositionProtein(featureLength, _startOffset, _startAnchor);
    Integer segmentEnd = getPositionProtein(featureLength, _endOffset, _endAnchor);

    DeflineBuilder defline = new DeflineBuilder(featureId);

    if(_requestedDeflineFields.contains("organism")){
      defline.appendRecordAttribute(record, ATTR_ORGANISM);
    }
    if(_requestedDeflineFields.contains("description")){
      defline.appendRecordAttribute(record, ATTR_GENE_PRODUCT);
    }
    if(_requestedDeflineFields.contains("position")){
      defline.appendPosition(chrom, segmentStart, segmentEnd, strand);
    }
    if(_requestedDeflineFields.contains("ui_choice")){
      defline.appendValue(
        getPositionDescProtein(_startOffset, "+", _startAnchor)
        + " to "
        + getPositionDescProtein(_endOffset, "-", _endAnchor)
      );
    }
    if(_requestedDeflineFields.contains("segment_length")){
      defline.appendSegmentLength(segmentStart, segmentEnd);
    }

    return List.of(BedLine.bed6(chrom, segmentStart, segmentEnd, defline, strand));
  }

  private static Integer getPositionProtein(Integer featureLength, int offset, Anchor anchor) throws WdkModelException {
    switch(anchor){
      case Start: return 1 + offset;
      case End: return featureLength - offset;
      default: throw new WdkModelException("Unsupported anchor type: " + anchor);
    }
  }

  private static String getPositionDescProtein(int offset, String sign, Anchor anchor){
    return offset == 0
        ? anchor.name()
        : anchor.name() + sign + offset;
  }
}
