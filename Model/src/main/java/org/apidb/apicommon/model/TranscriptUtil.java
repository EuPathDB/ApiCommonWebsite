package org.apidb.apicommon.model;

import java.util.Map;
import java.util.Optional;

import org.gusdb.fgputil.MapBuilder;
import org.gusdb.fgputil.validation.ValidObjectFactory.RunnableObj;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.answer.factory.AnswerValueFactory;
import org.gusdb.wdk.model.answer.spec.AnswerSpec;
import org.gusdb.wdk.model.query.spec.QueryInstanceSpec;
import org.gusdb.wdk.model.question.Question;
import org.gusdb.wdk.model.record.RecordClass;
import org.gusdb.wdk.model.user.Step;
import org.gusdb.wdk.model.user.StepContainer.ListStepContainer;
import org.gusdb.wdk.model.user.User;
import org.gusdb.wdk.model.user.UserCache;

public class TranscriptUtil {

  public static final String GENE_RECORDCLASS = "GeneRecordClasses.GeneRecordClass";
  public static final String TRANSCRIPT_RECORDCLASS = "TranscriptRecordClasses.TranscriptRecordClass";

  private static final String XFORM_QUESTION_NAME = "GeneRecordQuestions.GenesFromTranscripts";
  private static final String XFORM_STEP_ID_PARAM_NAME = "gene_result";

  public static final boolean isGeneRecordClass(String name) {
    return GENE_RECORDCLASS.equals(name);
  }

  public static final boolean isGeneRecordClass(RecordClass recordClass) {
    return isGeneRecordClass(recordClass.getFullName());
  }

  public static final boolean isTranscriptRecordClass(String name) {
    return TRANSCRIPT_RECORDCLASS.equals(name);
  }

  public static final boolean isTranscriptRecordClass(RecordClass recordClass) {
    return isTranscriptRecordClass(recordClass.getFullName());
  }

  public static final boolean isTranscriptQuestion(Question question) {
    return isTranscriptRecordClass(question.getRecordClass());
  }

  public static RunnableObj<AnswerSpec> transformToRunnableGeneAnswerSpec(
      WdkModel wdkModel, User user, Step transcriptStep) throws WdkModelException {

    Question question = wdkModel.getQuestionByFullName(XFORM_QUESTION_NAME)
        .orElseThrow(() -> new WdkModelException("Can't find xform with name: " + XFORM_QUESTION_NAME));

    if (question.getParamMap().size() != 1 || !question.getParamMap().containsKey(XFORM_STEP_ID_PARAM_NAME)) {
      throw new WdkModelException("Expected question " + XFORM_QUESTION_NAME +
          " to have exactly one parameter named " + XFORM_STEP_ID_PARAM_NAME);
    }

    Map<String, String> transformParams = new MapBuilder<String, String>(
        XFORM_STEP_ID_PARAM_NAME, String.valueOf(transcriptStep.getStepId())).toMap();

    return AnswerSpec
        .builder(wdkModel)
        .setQuestionFullName(XFORM_QUESTION_NAME)
        .setQueryInstanceSpec(QueryInstanceSpec.builder()
            .putAll(transformParams)
            .setAssignedWeight(10)
        )
        .buildRunnable(user, new ListStepContainer(transcriptStep));
  }

  public static AnswerValue transformToGeneAnswer(AnswerValue transcriptAnswer) throws WdkModelException {

    WdkModel model = transcriptAnswer.getWdkModel();
    User user = transcriptAnswer.getUser();

    RunnableObj<Step> step = Step.builder(model, user.getUserId(), model.getStepFactory().getNewStepId())
        .setAnswerSpec(AnswerSpec.builder(transcriptAnswer.getAnswerSpec()))
        .buildRunnable(new UserCache(user), Optional.empty());

    AnswerValue geneAnswer = AnswerValueFactory.makeAnswer(transcriptAnswer.getUser(),
        transformToRunnableGeneAnswerSpec(model, user, step.get()));

    // make sure gene answer uses same page size as transcript answer
    return geneAnswer.cloneWithNewPaging(transcriptAnswer.getStartIndex(), transcriptAnswer.getEndIndex());
  }
}
