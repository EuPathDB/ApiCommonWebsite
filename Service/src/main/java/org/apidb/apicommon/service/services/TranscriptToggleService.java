package org.apidb.apicommon.service.services;

import javax.ws.rs.Consumes;
import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.apidb.apicommon.model.filter.RepresentativeTranscriptFilter;
import org.gusdb.fgputil.validation.ValidationLevel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.answer.spec.AnswerSpec;
import org.gusdb.wdk.model.answer.spec.AnswerSpecBuilder;
import org.gusdb.wdk.model.user.Step;
import org.gusdb.wdk.model.user.StepFactoryHelpers.UserCache;
import org.gusdb.wdk.service.service.AbstractWdkService;
import org.json.JSONObject;

@Path("/step/{stepId}/transcript-view/config")
public class TranscriptToggleService extends AbstractWdkService {

  private static final Logger LOG = Logger.getLogger(TranscriptToggleService.class);

  @POST
  @Consumes(MediaType.APPLICATION_JSON)
  @Produces(MediaType.TEXT_PLAIN)
  public void setTranscriptFlag(@PathParam("stepId") Integer stepId, String body) throws WdkModelException {

    LOG.info("Received transcript toggle POST request for step ID " + stepId + " and body " + body);
    JSONObject input = new JSONObject(body);

    boolean filterTurnedOn = input.getBoolean(RepresentativeTranscriptFilter.FILTER_NAME);
    LOG.info("Action is to turn filter: " + filterTurnedOn);

    Step step = getWdkModel().getStepFactory().getStepById(stepId, ValidationLevel.SYNTACTIC)
        .orElseThrow(() -> new NotFoundException("No step exists with ID " + stepId));

    if (getSessionUser().getUserId() != step.getUser().getUserId()) {
      LOG.warn("Attempt made to edit Step " + stepId + " by non-owner (user id " +
          getSessionUser().getUserId() + "); session expired?");
      throw new ForbiddenException(AbstractWdkService.PERMISSION_DENIED);
    }

    AnswerSpecBuilder newSpec = AnswerSpec.builder(step.getAnswerSpec());
    if (filterTurnedOn) {
      newSpec.getViewFilterOptions().addFilterOption(RepresentativeTranscriptFilter.FILTER_NAME, new JSONObject());
    }
    else {
      newSpec.getViewFilterOptions().removeAll(fo -> fo.getFilterName().equals(RepresentativeTranscriptFilter.FILTER_NAME));
    }

    Step newStep = Step.builder(step).setAnswerSpec(newSpec)
        .build(new UserCache(step.getUser()), ValidationLevel.NONE, step.getStrategy());

    // since view filters do not affect downstream steps, we can just save the step here
    getWdkModel().getStepFactory().updateStep(newStep);
  }
}
