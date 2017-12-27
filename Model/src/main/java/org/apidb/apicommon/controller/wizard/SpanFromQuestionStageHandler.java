package org.apidb.apicommon.controller.wizard;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.gusdb.wdk.controller.CConstants;
import org.gusdb.wdk.controller.action.ProcessBooleanAction;
import org.gusdb.wdk.controller.action.ProcessQuestionAction;
import org.gusdb.wdk.controller.actionutil.ActionUtility;
import org.gusdb.wdk.controller.form.QuestionForm;
import org.gusdb.wdk.controller.form.WizardForm;
import org.gusdb.wdk.controller.wizard.ProcessBooleanStageHandler;
import org.gusdb.wdk.model.Utilities;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.jspwrap.QuestionBean;
import org.gusdb.wdk.model.jspwrap.StepBean;
import org.gusdb.wdk.model.jspwrap.StrategyBean;
import org.gusdb.wdk.model.jspwrap.UserBean;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.gusdb.wdk.model.query.param.values.StableValues;
import org.gusdb.wdk.model.query.param.values.ValidStableValuesFactory;
import org.gusdb.wdk.model.query.param.values.ValidStableValuesFactory.CompleteValidStableValues;

public class SpanFromQuestionStageHandler extends ShowSpanStageHandler {

  public static final String PARAM_CUSTOM_NAME = "customName";
  public static final String PARAM_STRATEGY = "strategy";
  public static final String PARAM_FILTER = "customName";

    private static final Logger logger = Logger.getLogger(SpanFromQuestionStageHandler.class);

    @Override
    public StepBean getChildStep(ActionServlet servlet,
            HttpServletRequest request, HttpServletResponse response,
            WizardForm wizardForm) throws Exception {
        logger.debug("Entering SpanFromQuestionStageHandler....");

        UserBean user = ActionUtility.getUser(request);

        // create a new step from question
        String questionName = request.getParameter(CConstants.QUESTION_FULLNAME_PARAM);
        if (questionName == null || questionName.length() == 0)
            throw new WdkUserException("Required "
                    + CConstants.QUESTION_FULLNAME_PARAM + " is missing.");

        WdkModelBean wdkModel = ActionUtility.getWdkModel(servlet);
        QuestionBean question = wdkModel.getQuestion(questionName);

        // prepare the params
        QuestionForm questionForm = new QuestionForm();
        questionForm.copyFrom(wizardForm);
        questionForm.setServlet(servlet);
        questionForm.setQuestion(question);

        StableValues params = ProcessQuestionAction.prepareParams(user, request, questionForm);

        // get the assigned weight
        String strWeight = request.getParameter(CConstants.WDK_ASSIGNED_WEIGHT_KEY);
        boolean hasWeight = (strWeight != null && strWeight.length() > 0);
        int weight = Utilities.DEFAULT_WEIGHT;
        if (hasWeight) {
            if (!strWeight.matches("[\\-\\+]?\\d+"))
                throw new WdkUserException("Invalid weight value: '"
                        + strWeight + "'. Only integers are allowed.");
            if (strWeight.length() > 9)
                throw new WdkUserException("Weight number is too big: "
                        + strWeight);
            weight = Integer.parseInt(strWeight);
        }

        // create a step from the input
        String filterName = request.getParameter(PARAM_FILTER);
        long stepId = Long.valueOf(request.getParameter(CConstants.WDK_STEP_ID_KEY));
        long strategyId = Long.valueOf(request.getParameter(CConstants.WDK_STRATEGY_ID_KEY));
        
        StrategyBean strategy = user.getStrategy(strategyId);

        StepBean childStep = null;
        String importStrategyId = request.getParameter("importStrategy");
        if (questionName.length() > 0) {
          // a question name specified, either create a step from it, or revise a current step
          String action = request.getParameter(ProcessBooleanAction.PARAM_ACTION);
          if (action.equals(WizardForm.ACTION_REVISE)) {
            childStep = ProcessBooleanStageHandler.updateStepWithQuestion(
                servlet, request, wizardForm, strategy, questionName, user, stepId);
          }
          else {
            CompleteValidStableValues validParams = ValidStableValuesFactory.createFromCompleteValues(user.getUser(), params);
            childStep = user.createStep(null, question, validParams, filterName, false, weight);
          }
        }
        else if (importStrategyId != null && importStrategyId.length() > 0) {
          // a step specified, it must come from an insert strategy. make a
          // copy of it, and mark it as collapsable.
          childStep = ProcessBooleanStageHandler.createStepFromStrategy(
              user, strategy, Long.valueOf(importStrategyId));
        }

        String customName = request.getParameter(PARAM_CUSTOM_NAME);
        if (customName != null && customName.trim().length() > 0) {
            childStep.setCustomName(customName);
            childStep.update(false);
        }

        logger.debug("Leaving SpanFromQuestionStageHandler....");
        return childStep;
    }

}
