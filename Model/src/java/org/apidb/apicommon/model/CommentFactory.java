/**
 * 
 */
package org.apidb.apicommon.model;

import java.io.IOException;
import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.gusdb.wdk.model.RDBMSPlatformI;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.implementation.SqlUtils;
import org.xml.sax.SAXException;

/**
 * @author xingao
 * 
 */
public class CommentFactory {

    private static CommentFactory factory;

    private RDBMSPlatformI platform;
    private CommentConfig config;

    public static void initialize(URL commentConfigXmlUrl)
            throws WdkModelException {
        try {
            // parse and load the configuration
            CommentConfig config = CommentConfigParser.parseXmlFile(commentConfigXmlUrl);

            // create a platform object
            RDBMSPlatformI platform = (RDBMSPlatformI) Class.forName(
                    config.getPlatformClass()).newInstance();
            platform.init(config.getConnectionUrl(), config.getLogin(),
                    config.getPassword(), config.getMinIdle(),
                    config.getMaxIdle(), config.getMaxWait(),
                    config.getMaxActive(), config.getInitialSize(),
                    commentConfigXmlUrl.getFile());

            // create a factory instance
            factory = new CommentFactory(platform, config);
        } catch (InstantiationException ex) {
            throw new WdkModelException(ex);
        } catch (IllegalAccessException ex) {
            throw new WdkModelException(ex);
        } catch (ClassNotFoundException ex) {
            throw new WdkModelException(ex);
        } catch (SAXException ex) {
            throw new WdkModelException(ex);
        } catch (IOException ex) {
            throw new WdkModelException(ex);
        }
    }

    public static CommentFactory getInstance() throws WdkModelException {
        if (factory == null)
            throw new WdkModelException(
                    "Please initialize the factory properly.");
        return factory;
    }

    private CommentFactory(RDBMSPlatformI platform, CommentConfig config) {
        this.platform = platform;
        this.config = config;
    }

    public CommentTarget getCommentTarget(String internalValue)
            throws WdkModelException {
        String schema = config.getCommentSchema();

        // load the comment target definition of the given internal value

        ResultSet rs = null;
        CommentTarget target = null;
        PreparedStatement ps = null;
        String query = null;
        try {
        	query = "SELECT * FROM " + schema + ".comment_target WHERE comment_target_id=?";
            ps = SqlUtils.getPreparedStatement(platform.getDataSource(), query);
            ps.setString(1, internalValue);
            rs = ps.executeQuery();
            if (!rs.next())
                throw new WdkModelException("The comment target cannot be "
                        + "found with the given internal value: "
                        + internalValue);

            target = new CommentTarget(internalValue);
            target.setDisplayName(rs.getString("comment_target_name"));
            target.setRequireLocation((rs.getInt("require_location") != 0));

        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        } finally {
            // close the connection
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }
        }
        return target;
    }

    public void addComment(Comment comment) throws WdkModelException {
        String schema = config.getCommentSchema();

        PreparedStatement ps = null;
        // get a new comment id
        try {
            // DataSource dataSource = platform.getDataSource();
            String commentId = platform.getNextId(schema, "comments");

            ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(),
                    "INSERT INTO "
                            + schema
                            + ".comments (comment_id, email, "
                            + "comment_date, comment_target_id, stable_id, conceptual, "
                            + "project_name, project_version, headline, content, "
                            + "location_string, review_status_id) "
                            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");

            long currentMillis = System.currentTimeMillis();

            ps.setInt(1, Integer.parseInt(commentId));
            ps.setString(2, comment.getEmail());
            ps.setDate(3, new java.sql.Date(currentMillis));
            ps.setString(4, comment.getCommentTarget());
            ps.setString(5, comment.getStableId());
            ps.setBoolean(6, comment.isConceptual());
            ps.setString(7, comment.getProjectName());
            ps.setString(8, comment.getProjectVersion());
            ps.setString(9, comment.getHeadline());
            ps.setString(10, comment.getContent());
            ps.setString(11, comment.getLocationString());
            ps.setString(12, Comment.COMMENT_REVIEW_STATUS_UNKNOWN);

            ps.execute();

            // update the fields of comment
            comment.setCommentDate(new java.util.Date(currentMillis));

            // then add the location information
            saveLocations(commentId, comment);

            // then add the eternal database information
            saveExternalDbs(commentId, comment);
        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        }
    }

    private void saveLocations(String commentId, Comment comment)
            throws SQLException {
        String schema = config.getCommentSchema();

        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + schema + ".locations (comment_id, ");
        sql.append("location_id, location_start, location_end, is_reverse, ");
        sql.append("coordinate_type) VALUES (?, ?, ?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                    sql.toString());

            Location[] locations = comment.getLocations();
            for (Location location : locations) {
                String locationId = platform.getNextId(schema, "locations");
                statement.setInt(1, Integer.parseInt(commentId));
                statement.setInt(2, Integer.parseInt(locationId));
                statement.setLong(3, location.getLocationStart());
                statement.setLong(4, location.getLocationEnd());
                statement.setBoolean(5, location.isReversed());
                statement.setString(6, location.getCoordinateType());
                statement.execute();
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    /**
     * For the first release, this method hard-code the external database name
     * and version, instead of looking up directly in GUS. This avoids the
     * backward dblink requirement; The site should provide such information to
     * the comment factory in future releases.
     * 
     * @param commentId
     * @param comment
     * @throws SQLException
     */
    private void saveExternalDbs(String commentId, Comment comment)
            throws SQLException {
        String schema = config.getCommentSchema();
        // String dblink = config.getProjectDbLink();
        // String stableId = comment.getStableId();
        DataSource dataSource = platform.getDataSource();

        // get a set of matched external databases
        StringBuffer sql = new StringBuffer();
        // sql.append("( SELECT DISTINCT ed.name AS external_database_name, "
        // + " edr.version AS external_database_version ");
        // sql.append(" FROM sres.ExternalDatabase" + dblink + " ed, ");
        // sql.append(" sres.DbRef" + dblink + " dr, ");
        // sql.append(" sres.ExternalDatabaseRelease" + dblink + " edr, ");
        // sql.append(" dots.dbrefNaFeature" + dblink + " drnf, ");
        // sql.append(" dots.GeneFeature" + dblink + " gf ");
        // sql.append(" WHERE dr.external_database_release_id =
        // edr.external_database_release_id "
        // + " AND edr.external_database_id = ed.external_database_id "
        // + " AND drnf.db_ref_id = dr.db_ref_id "
        // + " AND drnf.na_feature_id = gf.na_feature_id ");
        // sql.append(" AND gf.source_id = ?) ");
        // sql.append("union "
        // + "( SELECT DISTINCT ed.name AS external_database_name, "
        // + " edr.version AS external_database_version ");
        // sql.append(" FROM sres.ExternalDatabase" + dblink + " ed, ");
        // sql.append("sres.DbRef" + dblink + " dr, ");
        // sql.append(" sres.ExternalDatabaseRelease" + dblink + " edr, ");
        // sql.append(" dots.dbrefNaSequence" + dblink + " drns, ");
        // sql.append("dots.SplicedNaSequence" + dblink + " sns ");
        // sql.append(" WHERE dr.external_database_release_id =
        // edr.external_database_release_id "
        // + " AND edr.external_database_id = ed.external_database_id "
        // + " AND drns.db_ref_id = dr.db_ref_id "
        // + " AND drns.na_sequence_id = sns.na_sequence_id ");
        // sql.append(" AND sns.source_id = ?)");
        // ResultSet rs = null;
        // PreparedStatement ps = null;
        PreparedStatement queryDb = null, insertDb = null, insertLink = null;
        try {
            // ps = SqlUtils.getPreparedStatement(dataSource, sql.toString());
            // ps.setString(1, stableId);
            // ps.setString (2, stableId);
            //        	
            // rs = ps.executeQuery();

            // construct prepared statements
            sql = new StringBuffer();
            sql.append("SELECT external_database_id ");
            sql.append("FROM " + schema + ".external_databases ");
            sql.append("WHERE external_database_name = ? "
                    + "AND external_database_version = ?");
            queryDb = SqlUtils.getPreparedStatement(dataSource, sql.toString());

            sql = new StringBuffer();
            sql.append("INSERT INTO " + schema + ".external_databases ");
            sql.append("(external_database_id, external_database_name, "
                    + "external_database_version) VALUES (?, ?, ?)");
            insertDb = SqlUtils.getPreparedStatement(dataSource, sql.toString());

            sql = new StringBuffer();
            sql.append("INSERT INTO " + schema + ".comment_external_database ");
            sql.append("(external_database_id, comment_id) VALUES (?, ?)");
            insertLink = SqlUtils.getPreparedStatement(dataSource,
                    sql.toString());

            // while (rs.next()) {
            // String externalDbName = rs.getString("external_database_name");
            // String externalDbVersion =
            // rs.getString("external_database_version");
            String externalDbName = "PlasmoDB_Temp";
            String externalDbVersion = "ver_1.0";
            int externalDbId;

            // check if the external db entry exists
            queryDb.setString(1, externalDbName);
            queryDb.setString(2, externalDbVersion);
            ResultSet rsDb = queryDb.executeQuery();
            if (!rsDb.next()) { // no entry, add one
                externalDbId = Integer.parseInt(platform.getNextId(schema,
                        "external_databases"));
                insertDb.setInt(1, externalDbId);
                insertDb.setString(2, externalDbName);
                insertDb.setString(3, externalDbVersion);
                insertDb.execute();
            } else { // has entry, get the external_database_id
                externalDbId = rsDb.getInt("external_database_id");
            }
            rsDb.close();

            // add the reference link
            insertLink.setInt(1, externalDbId);
            insertLink.setInt(2, Integer.parseInt(commentId));
            insertLink.execute();
            // }
        } finally {
            // close statements and result set
            // SqlUtils.closeResultSet(rs);
            SqlUtils.closeStatement(queryDb);
            SqlUtils.closeStatement(insertDb);
            SqlUtils.closeStatement(insertLink);
        }
    }

    public Comment getComment(String commentId) throws WdkModelException {
        String schema = config.getCommentSchema();

        StringBuffer sql = new StringBuffer();
        sql.append("SELECT * FROM " + schema + ".comments ");
        sql.append("WHERE comment_id = ?");
        ResultSet rs = null;
        PreparedStatement ps = null;
        try {

            ps = SqlUtils.getPreparedStatement(platform.getDataSource(),
                    sql.toString());
            ps.setString(1, commentId);
            rs = ps.executeQuery();

            if (!rs.next())
                throw new WdkModelException("Comment of the given id '"
                        + commentId + "' cannot be found.");

            // construct a comment object
            Comment comment = new Comment(rs.getString("email"));
            comment.setCommentDate(rs.getDate("comment_date"));
            comment.setCommentTarget(rs.getString("comment_target_id"));
            comment.setConceptual(rs.getBoolean("conceptual"));
            comment.setContent(rs.getString("content"));
            comment.setHeadline(rs.getString("headline"));
            comment.setProjectName(rs.getString("project_name"));
            comment.setProjectVersion(rs.getString("project_version"));
            comment.setReviewStatus(rs.getString("review_status_id"));
            comment.setStableId(rs.getString("stable_id"));

            // load locations
            loadLocations(commentId, comment);

            // load external databases
            loadExternalDbs(commentId, comment);

            return comment;
        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        } finally {
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }
        }
    }

    private void loadLocations(String commentId, Comment comment)
            throws SQLException {
        String schema = config.getCommentSchema();

        StringBuffer sql = new StringBuffer();
        sql.append("SELECT location_start, location_end, is_reversed, ");
        sql.append("coordinate_type FROM " + schema + ".locations ");
        sql.append("WHERE comment_id = ?");
        ResultSet rs = null;

        PreparedStatement ps = null;
        try {

            ps = SqlUtils.getPreparedStatement(platform.getDataSource(),
                    sql.toString());
            ps.setString(1, commentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                long start = rs.getLong("location_start");
                long end = rs.getLong("location_end");
                boolean reversed = rs.getBoolean("is_reversed");
                String coordinateType = rs.getString("coordinate_type");
                comment.addLocation(reversed, start, end, coordinateType);
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadExternalDbs(String commentId, Comment comment)
            throws SQLException {
        String schema = config.getCommentSchema();

        StringBuffer sql = new StringBuffer();
        sql.append("SELECT ed.external_database_name, ed.external_database_version ");
        sql.append("FROM " + schema + ".external_databases ed, ");
        sql.append(schema + ".comment_external_database ced ");
        sql.append("WHERE ced.comment_id = ?");
        sql.append(" AND ced.external_database_id = ed.external_database_id");

        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = SqlUtils.getPreparedStatement(platform.getDataSource(),
                    sql.toString());
            ps.setString(1, commentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                String externalDbName = rs.getString("external_database_name");
                String externalDbVersion = rs.getString("external_database_version");
                comment.addExternalDatabase(externalDbName, externalDbVersion);
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }
}
