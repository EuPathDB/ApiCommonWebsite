<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- get wdkAnswer from requestScope -->
<jsp:useBean id="wdkUser" scope="session" type="org.gusdb.wdk.model.jspwrap.UserBean"/>
<c:set value="${requestScope.wdkAnswer}" var="wdkAnswer"/>
<c:set var="history_id" value="${requestScope.wdk_history_id}"/>
<c:set var="format" value="${requestScope.wdkReportFormat}"/>
<c:set var="allRecordIds" value="${wdkAnswer.allIdList}"/>

<c:set var="site" value="${wdkModel.displayName}"/>

<c:set var="CGI_URL" value="${applicationScope.wdkModel.properties['CGI_URL']}"/>


<!-- display page header -->
<site:header banner="Retrieve Genome Sequences" />

<!-- display description for page -->
<p><b>This reporter will retrieve the sequences of the genome records in your result.</b></p>

<!-- display the parameters of the question, and the format selection form -->
<wdk:reporter/>

<c:choose>
<c:when test="${fn:containsIgnoreCase(site, 'ApiDB')}">
  <form action="${CGI_URL}/Api_contigSrt" method="post">
</c:when>
<c:otherwise>
  <form action="${CGI_URL}/contigSrt" method="post">
</c:otherwise>
</c:choose>


    <input type="hidden" name="ids" value="${allRecordIds}">
    <input type="hidden" name="project_id" value="${wdkModel.name}"/>
    
    <table border="0" width="100%" cellpadding="4">

    <tr><td colspan="2">
        <input type="checkbox" name="revComp" value="protein">Reverse & Complement
    </td></tr>

    <tr><td colspan="2">
    <b>Choose the region of the sequence(s):</b>
    </td></tr>
    <tr><td colspan="2">
    <table cellpadding="4">
        <tr><td>Nucleotide postions</td>
            <td align="left">
                             <input name="start" value="1" size="6"> to
                             <input name="end" value="10000" size="6"></td></tr>
        <tr><td><a href="#help"><img src="images/toHelp.jpg" align="top" border='0'></a></td></tr>
    </table></td></tr>

        <td align="center"><input name="go" value="Get Sequences" type="submit"/></td>
        <td align="center"><input name="save" value="Save to File" type="submit"/></td></tr>
    </table>
  </form>

<hr>

<b><a name="help">Help</a></b>
  <br>
  <br>
Regions:
 <table width="100%" cellpadding="4">
   <tr>
      <td><i><b>relative to sequence start</b></i>
      <td>to retrieve, eg, the 100 bp upstream genomic region, use "begin at <i>start</i> +/- -100  end at <i>start</i> +/- -1".
   <tr>
      <td><i><b>relative to sequence stop</b></i>
      <td>to retrieve, eg, the last 10 amino acids of a protein, use "begin at <i>stop</i> +/- -9  end at <i>stop</i> +/- 0".
    <tr>
      <td><i><b>relative to sequence start and stop</b></i>
      <td>to retrieve, eg, a CDS with the  first and last 10 basepairs excised, use: "begin at <i>start</i> +/- 10 end at <i>stop</i> +/- -10".
    </tr>
  </table>

<table>
<tr>
  <td valign="top" class="dottedLeftBorder"></td> 
</tr>
</table> 
 
<site:footer/>
