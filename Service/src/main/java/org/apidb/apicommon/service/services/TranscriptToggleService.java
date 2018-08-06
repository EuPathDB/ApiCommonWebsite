package org.apidb.apicommon.service.services;

import javax.ws.rs.BadRequestException;
import javax.ws.rs.Consumes;
import javax.ws.rs.ForbiddenException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.log4j.Logger;
import org.apidb.apicommon.model.filter.RepresentativeTranscriptFilter;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.user.Step;
import org.gusdb.wdk.service.service.WdkService;
import org.json.JSONException;
import org.json.JSONObject;

@Path("/step/{stepId}/transcript-view/config")
public class TranscriptToggleService extends WdkService {

  private static final Logger LOG = Logger.getLogger(TranscriptToggleService.class);

  @POST
  @Consumes(MediaType.APPLICATION_JSON)
  @Produces(MediaType.TEXT_PLAIN)
  public Response setTranscriptFlag(@PathParam("stepId") Integer stepId, String body) throws WdkModelException {
    try {
      LOG.info("Received transcript toggle POST request for step ID " + stepId + " and body " + body);
      JSONObject input = new JSONObject(body);
      boolean filterTurnedOn = input.getBoolean(RepresentativeTranscriptFilter.FILTER_NAME);
      LOG.info("Action is to turn filter: " + filterTurnedOn);
      Step step = getWdkModel().getStepFactory().getStepById(stepId).orElseThrow(()-> new NotFoundException("No step found for ID " + stepId));
      if (getSessionUser().getUserId() != step.getUser().getUserId()) {
        LOG.warn("Attempt made to edit Step " + stepId + " by non-owner (user id " +
            getSessionUser().getUserId() + "); session expired?");
        throw new ForbiddenException(WdkService.PERMISSION_DENIED);
      }
      if (filterTurnedOn) {
        step.addViewFilterOption(RepresentativeTranscriptFilter.FILTER_NAME, new JSONObject());
      }
      else {
        step.removeViewFilterOption(RepresentativeTranscriptFilter.FILTER_NAME);
      }
      step.saveParamFilters();
      return Response.ok().build();
    }
    catch (WdkModelException e) {
      LOG.error("Unable to update transcript view flag for step " + stepId, e);
      throw new WdkModelException(e);
    }
    catch (JSONException e) {
      LOG.error("Unable to parse input JSON", e);
      throw new BadRequestException("JSON object required with property " +
          RepresentativeTranscriptFilter.FILTER_NAME + " (boolean).");
    }
  }
}
