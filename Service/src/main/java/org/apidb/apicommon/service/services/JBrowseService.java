package org.apidb.apicommon.service.services;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo; 
import javax.ws.rs.core.Context; 
import javax.ws.rs.core.MultivaluedMap;

import org.apache.log4j.Logger;
import org.gusdb.wdk.service.service.AbstractWdkService;
import org.json.JSONObject;

@Path("/jbrowse")
public class JBrowseService extends AbstractWdkService {

    @SuppressWarnings("unused")
    private static final Logger LOG = Logger.getLogger(JBrowseService.class);

    @GET
    @Path("stats/global")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseFeatures(@SuppressWarnings("unused") @QueryParam("feature") String feature) {
        return Response.ok(new JSONObject().put("featureDensity", 0.0002).toString()).build();
    }

    @GET
    @Path("features/{refseq_name}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseFeatures(@PathParam("refseq_name") String refseqName, 
                                       @Context UriInfo uriInfo,
                                       @QueryParam("feature") String feature,
                                       @QueryParam("start") String start,
                                       @QueryParam("end") String end)  throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();

        List<String> command = new ArrayList<String>();
        command.add(gusHome + "/bin/jbrowseFeatures");
        command.add(gusHome);
        command.add(refseqName);
        command.add(start);
        command.add(end);
        command.add(feature);

        MultivaluedMap<String, String> queryParams = uriInfo.getQueryParameters(); 
        for (String key : queryParams.keySet()) {
            String value = queryParams.getFirst(key);

            command.add(key + "=" + value);
        }

        String result = jsonStringFromCommand(command);

        return Response.ok(result).build();
    }


    @GET
    @Path("dnaseq/{organismAbbrev}/{study}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseDNASeqTracks(@PathParam("organismAbbrev") String organismAbbrev, 
                                           @PathParam("study") String study) throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();
        String projectId = getWdkModel().getProjectId();
        String buildNumber = getWdkModel().getBuildNumber();

        List<String> command = new ArrayList<String>();
        command.add(gusHome + "/bin/jbrowseDNASeqTracks");
        command.add(gusHome);
        command.add(organismAbbrev);
        command.add(study);
        command.add(projectId);
        command.add(buildNumber);

        String result = jsonStringFromCommand(command);

        return Response.ok(result).build();
    }


    @GET
    @Path("rnaseq/{organismAbbrev}/{study}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseRNASeqTracks(@PathParam("organismAbbrev") String organismAbbrev, 
                                           @PathParam("study") String study,
                                           @QueryParam("showIntronJunctions") String showIntronJunctions,
                                           @QueryParam("intronSizeLimit") String intronSizeLimit) throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();
        String projectId = getWdkModel().getProjectId();
        String buildNumber = getWdkModel().getBuildNumber();
        String webservicesDir = getWdkModel().getProperties().get("WEBSERVICEMIRROR");

        System.err.println("WEBSERVICEMIRROR=" + webservicesDir);

        List<String> command = new ArrayList<String>();
        command.add(gusHome + "/bin/jbrowseRNASeqTracks");
        command.add(gusHome);
        command.add(organismAbbrev);
        command.add(study);
        command.add(projectId);
        command.add(buildNumber);
        command.add(webservicesDir);
        command.add(showIntronJunctions);
        command.add(intronSizeLimit);

        String result = jsonStringFromCommand(command);

        return Response.ok(result).build();
    }



    @GET
    @Path("rnaseq/bigwig/{orgNameForFileNames}/{dataset}/{sampleDir}/{file}")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response getRNASeqBigwig(@PathParam("orgNameForFileNames") String orgNameForFileNames, 
                                           @PathParam("dataset") String dataset,
                                           @PathParam("sampleDir") String sampleDir,
                                           @PathParam("file") String file) throws IOException, InterruptedException {

        String projectId = getWdkModel().getProjectId();
        String buildNumber = getWdkModel().getBuildNumber();
        String webservicesDir = getWdkModel().getProperties().get("WEBSERVICEMIRROR");


        String path = webservicesDir + "/" + projectId + "/" + "build-" + buildNumber + "/" + orgNameForFileNames + "/" + "bigwig" + "/" + dataset + "/" + sampleDir + "/" + file;

        File fileFullPath = new File(path);

        return Response.ok(fileFullPath, MediaType.APPLICATION_OCTET_STREAM)
            //            .header("Content-Disposition", "attachment; filename=\"" + fileFullPath.getName() + "\"" ) //optional
            .build();
    }



    @GET
    @Path("seq/{organismAbbrev}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseRefSeqs(@PathParam("organismAbbrev") String organismAbbrev )  throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();

        List<String> command = new ArrayList<String>();
        command.add(gusHome + "/bin/jbrowseRefSeqs");
        command.add(gusHome);
        command.add(organismAbbrev);

        String result = jsonStringFromCommand(command);

        return Response.ok(result).build();
    }


    @GET
    @Path("names/{organismAbbrev}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getJbrowseNames(@PathParam("organismAbbrev") String organismAbbrev, @QueryParam("equals") String eq, @QueryParam("startswith") String startsWith)  throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();

        boolean isPartial = true;
        String sourceId = startsWith;

        if(eq != null && !eq.equals("")) {
            isPartial = false;
            sourceId = eq;
        }

        List<String> command = new ArrayList<String>();
        command.add(gusHome + "/bin/jbrowseNames");
        command.add(gusHome);
        command.add(organismAbbrev);
        command.add(String.valueOf(isPartial));
        command.add(sourceId);

        String result = jsonStringFromCommand(command);

        return Response.ok(result).build();
    }


    public String jsonStringFromCommand (List<String> command) throws IOException, InterruptedException {

        String gusHome = getWdkModel().getGusHome();
        ProcessBuilder pb = new ProcessBuilder(command);
        Map<String, String> env = pb.environment();
        env.put("GUS_HOME", gusHome);

        pb.redirectErrorStream(true);

        Process p = pb.start();

        BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));

        String result = "";
        String line;
        while ((line = br.readLine()) != null) {
            result += line;
        }

        p.waitFor();

        if(p.exitValue() != 0) {
            throw new RuntimeException(result);
        }

        if(result.equals("")) {
            result = "{}";
        }

        return result;
    }


}
