package org.apidb.apicommon.model.view;

import java.util.Arrays;
import java.util.Map;

import org.gusdb.fgputil.functional.TreeNode;
import org.gusdb.wdk.model.SelectableItem;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.FieldTree.NameMatchPredicate;
import org.gusdb.wdk.model.jspwrap.StepBean;
import org.gusdb.wdk.model.record.attribute.AttributeField;
import org.gusdb.wdk.model.user.Step;

public abstract class AbstractTranscriptViewHandler extends AltSpliceViewHandler {

  private static final String TRANSCRIPT_ID_FIELD = "transcript_link";


  private static final String[] FIELDS_TO_REMOVE = {
    //TRANSCRIPT_ID_FIELD, "gene_transcript_count", "transcripts_found_per_gene"
  };

  @Override
  protected void customizeAvailableAttributeTree(Step step, TreeNode<SelectableItem> root, WdkModel model) {
    root.removeAll(new NameMatchPredicate(Arrays.asList(FIELDS_TO_REMOVE)));
  }


  @Override
  protected AttributeField[] getLeftmostFields(StepBean stepBean) throws WdkModelException {
    Map<String,AttributeField> fieldMap = stepBean.getStep().getQuestion().getRecordClass().getAttributeFieldMap();
    AttributeField[] myAttrFieldArray = new AttributeField[]{
        fieldMap.get(PRIMARY_KEY_FIELD), fieldMap.get(TRANSCRIPT_ID_FIELD)
    };
    for(int i=0; i < myAttrFieldArray.length; i++) {
      myAttrFieldArray[i] = myAttrFieldArray[i].clone();
      myAttrFieldArray[i].setRemovable(false);
    }
    return myAttrFieldArray;
  }
}
