package org.eupathdb.sitesearch.data.comments;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status.Family;

import org.apache.log4j.Logger;
import org.gusdb.fgputil.db.pool.DatabaseInstance;
import org.gusdb.fgputil.db.runner.SQLRunner;
import org.gusdb.fgputil.solr.SolrRuntimeException;
import org.json.JSONObject;

/***
 * 
 * @author Steve
 * 
 * Find all documents in Solr with out-of-date user comment fields relative to the comment database.
 * Update each such document in Solr with current comment data.
 * 
 * Solr documents will have two user comment fields, both multi-valued.  Every comment associated with
 * the document will have a value in each field
 *   - comment IDs
 *   - comment contents
 *   
 *  The strategy of this updater is to compare sorted streams of IDs from Solr and the database.  When
 *  a difference is found, remember the document.
 *  
 *  Finally iterate through the list of stale documents and individually read the full data from the database
 *  and update the document in Solr
 *  
 *  The design of this updater assumes that the vast majority of comments are up-to-date in Solr
 *  (having been written there when Solr was originally populated with documents).
 *  It is not intended to support large cardinality updates.
 */
public class CommentUpdater {

  private static final Logger LOG = Logger.getLogger(CommentUpdater.class);

  private final String _solrUrl;
  private final DatabaseInstance _commentDb;
  private final String _commentSchema;

  public CommentUpdater(String solrUrl, DatabaseInstance commentDb, String commentSchema) {
    _solrUrl = solrUrl;
    _commentDb = commentDb;
    _commentSchema = commentSchema;
  }

  public void performSync() {
    findDocumentsToUpdate().forEach( (idTuple) -> updateDocumentComment(idTuple) );
  }

  /**
   * Get an in-memory list of record IDs for those records that are out of date in Solr
   * @return
   */
  private List<RecordIdTuple> findDocumentsToUpdate() {
    
    // sql to find sorted (source_id, comment_id) tuples from userdb
    String sqlSelect = "select source_id, comment_target_id as record_type, comment_id " +
        "from apidb.textsearchablecomment tsc, " + _commentSchema + ".comments c " +
        "where tsc.comment_id = c.comment_id" +
        "order by record_type asc, source_id asc, comment_id asc"; 
    
    return new SQLRunner(_commentDb.getDataSource(), sqlSelect)
      .executeQuery(rs -> {
        Response solrResponse = null;
        try {
          // get similar info from solr
          solrResponse = getSolrResponse();
          BufferedReader solrData = new BufferedReader(new InputStreamReader((InputStream)solrResponse.getEntity()));

          // compare the streams to find differences
          return findStaleDocuments(solrData, rs);
        }
        finally {
          if (solrResponse != null) solrResponse.close();
        }
      });
  }

  /**
   * Iterate through parallel streams, comparing them.  
   * 
   * The rows from solr are one per document, sorted by wdkPrimaryKey, with the comment IDs 
   * in a single cell.  Those comments to be serialized and sorted.
   * 
   * The rows from the database are one per (recordId, commentId) tuple and are already sorted.
   * 
   * @param solrData
   * @param rs
   * @return
   */
  private List<RecordIdTuple> findStaleDocuments(BufferedReader solrData, ResultSet rs) {
    // TODO: write this method
    return new ArrayList<>();
  }

  /**
   * 
   * Get a csv response from Solr.  The 3 columns are docId, wdkPrimaryKeyString,  and comma-delimited list of commentIDs.
   * Rows are sorted by wdkPrimaryKeyString
   */
  private Response getSolrResponse() {
    String searchUrlSubpath = "/select" +
        "?q=MULTITEXT__gene_UserCommentContent:*" +    // any document with user comments
        "&fl=id,wdkPrimaryKeyString,userCommentIds" +  // output fields
        "&rows=1000000" +                              // row count: infinite
        "&wt=csv" +                                    // output format csv
        "&sort=wdkPrimaryKeyString desc";              // sorting
    Client client = ClientBuilder.newClient();
    String finalUrl = _solrUrl + searchUrlSubpath;
    LOG.info("Querying SOLR with: " + finalUrl);
    WebTarget webTarget = client.target(finalUrl);
    Invocation.Builder invocationBuilder = webTarget.request(MediaType.APPLICATION_JSON);
    Response response = invocationBuilder.get();
    if (!response.getStatusInfo().getFamily().equals(Family.SUCCESSFUL)) {
      throw new RuntimeException("SOLR responded with error");
    }
    return response;
  }

  /**
   * For a given record, get up-to-date comment info from the database.  Format into JSON
   * to be submitted as a document update to solr.
   * 
   * TODO: this method formats a solr document ID.  Might be better to get it from solr in the 
   * csv output, and remember it.
   * 
   * @param idTuple
   */
  private void updateDocumentComment(RecordIdTuple idTuple) {
    DocumentCommentsInfo comments = getCorrectCommentsForOneDocument(idTuple, _commentDb.getDataSource());
    JSONObject updateJson = new JSONObject(); 
    updateJson.put("id", idTuple.recordType + "__" + idTuple.sourceId); // concoct a valid solr unique ID
    updateJson.put("userCommentIds", comments.commentIds);
    updateJson.put("UserCommentContent", comments.commentContents);
    updateSolrDocument(updateJson);
  }
  
  /**
   * Get the up-to-date comments info from the database, for the provided wdk record
   * @param idTuple
   * @param commentDbDataSource
   * @return
   */
  private DocumentCommentsInfo getCorrectCommentsForOneDocument(RecordIdTuple idTuple, DataSource commentDbDataSource) {
    
    String sqlSelect = "select comment_id, content " +
        "from apidb.textsearchablecomment " +
        "where source_id = '" + idTuple.sourceId + "'"; 
    
    return new SQLRunner(commentDbDataSource, sqlSelect)
      .executeQuery(rs -> {
        DocumentCommentsInfo comments = new DocumentCommentsInfo();
        while (rs.next()) {
          comments.commentIds.add(rs.getInt("comment_id"));
          comments.commentContents.add(rs.getString("content"));
        }
        return comments;
      });
  }

  /***
   * Apply a JSON update to Solr
   * @param jsonBody
   */
  private void updateSolrDocument(JSONObject jsonBody) {
    Response response = null;
    try {
      String urlSubpath = "/update";  
      Client client = ClientBuilder.newClient();
      String finalUrl = _solrUrl + urlSubpath;
      WebTarget webTarget = client.target(finalUrl);
      Invocation.Builder invocationBuilder = webTarget.request(MediaType.APPLICATION_JSON);
      response = invocationBuilder.post(Entity.entity(jsonBody.toString(), MediaType.APPLICATION_JSON));
      if (!response.getStatusInfo().getFamily().equals(Family.SUCCESSFUL)) {
        throw new SolrRuntimeException("Failed to execute SOLR update. " + response.getEntity().toString());
      }
    }
    finally {
      if (response != null) response.close();
    }
  }
  
  /**
   * A tuple holding a record ID from the database (eg a Gene ID)
   * @author Steve
   *
   */
  public class RecordIdTuple {
    String recordType;
    String sourceId;
  }
  
  /**
   * Models comment info found in a single Solr document
   * @author Steve
   *
   */
  public class DocumentCommentsInfo { 
    public DocumentCommentsInfo() {
      commentIds = new ArrayList<Integer>();
      commentContents = new ArrayList<String>();
    }
    List<Integer> commentIds;
    List<String> commentContents;
  }
}
