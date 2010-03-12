<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- get wdkAnswer from requestScope -->
<jsp:useBean id="wdkUser" scope="session" type="org.gusdb.wdk.model.jspwrap.UserBean"/>
<c:set value="${requestScope.wdkStep}" var="wdkStep"/>
<c:set var="wdkAnswer" value="${wdkStep.answerValue}" />
<c:set var="history_id" value="${requestScope.step_id}"/>
<c:set var="format" value="${requestScope.wdkReportFormat}"/>
<c:set var="allRecordIds" value="" />
<c:forEach items="${wdkAnswer.allIds}" var="id">
    <c:if test="${allRecordIds != ''}"><c:set var="allRecordIds" value="${allRecordIds}," /></c:if>
    <c:set var="allRecordIds" value="${allRecordIds}${id[0]}" />
</c:forEach>

<c:set var="site" value="${wdkModel.displayName}"/>

<!-- display page header -->
<site:header refer="srt" banner="Retrieve Gene Sequences" />

<!-- display description for page -->
<p><b>This reporter will retrieve the sequences of the genes in your result.</b></p>

<!-- display the parameters of the question, and the format selection form -->
<wdk:reporter/>

<%--
<c:choose>
<c:when test="${fn:containsIgnoreCase(site, 'EuPathDB')}">
  <form action="/cgi-bin/Api_geneSrt" method="post">
</c:when>
<c:otherwise>
--%>
  <form action="/cgi-bin/geneSrt" method="post">
<%--
</c:otherwise>
</c:choose>
--%>


    <input type="hidden" name="ids" value="${allRecordIds}">
    <input type="hidden" name="project_id" value="${wdkModel.name}"/>
    
    <table border="0" width="100%" cellpadding="4">

    <tr><td colspan="2">
    <b>Choose the type of sequence:</b>
        <input type="radio" name="type" value="genomic" checked onclick="setEnable(true)">genomic
        <input type="radio" name="type" value="protein" onclick="setEnable(false)">protein
        <input type="radio" name="type" value="CDS" onclick="setEnable(false)">CDS
        <input type="radio" name="type" value="processed_transcript" onclick="setEnable(false)">transcript
    </td></tr>

    <tr>
        <td colspan="2">
<table id="offsetOptions" cellpadding="2">
        <tr><td colspan="3">
                <b>Choose the region of the sequence(s):</b>
            </td>
        </tr>
        <tr>
            <td>begin at</td>
            <td align="left">
		<select name="upstreamAnchor">
                    <option value="Start" selected>Start</option>
                    <option value="CodeStart">translation start (ATG)</option>
                    <option value="CodeEnd">translation stop codon</option>
                    <option value="End">Stop</option>
                </select>
            </td>
            <td align="left">
                <select name="upstreamSign">
		    <option value="plus" selected>+</option>
                    <option value="minus">-</option>
                </select>
	    </td>
            <td align="left">
                <input id="upstreamOffset" name="upstreamOffset" value="0" size="6"/> nucleotides
            </td>
        </tr>
        <tr>
            <td>end at</td>
            <td align="left">
		<select name="downstreamAnchor">
                    <option value="Start">Start</option>
                    <option value="CodeStart">translation start (ATG)</option>
                    <option value="CodeEnd">translation stop codon</option>
                    <option value="End" selected>Stop</option>
                </select>
            </td>
            <td align="left">
                <select name="downstreamSign">
		    <option value="plus" selected>+</option>
                    <option value="minus">-</option>
                </select>
	    </td>
            <td align="left">
                <input id="downstreamOffset" name="downstreamOffset" value="0" size="6"> nucleotides
            </td>
        </tr>
       </table>
      </td>
    </tr>
    <tr><td valign="top" nowrap><b>Download Type</b>:
            <input type="radio" name="downloadType" value="text">Save to File</input>
            <input type="radio" name="downloadType" value="plain" checked>Show in Browser</input>
        </td></tr>
    <tr><td align="center"><input name="go" value="Get Sequences" type="submit"/></td></tr>

    </table>
  </form>

<hr>

<b><a name="help">Help</a></b>
  <br>
  <br>
<img src="images/genemodel.gif" align="top" > 

<br>
Types of sequences:
 <table width="100%" cellpadding="4">
 <tr>
      <td><i><b>protein</b></i>
      <td>the predicted translation of the gene
 </tr>
 <tr>
       <td><i><b>CDS</b></i>
       <td>the coding sequence, excluding UTRs (introns spliced out)
 </tr>
 <tr>
        <td><i><b>transcript</b></i>
        <td>the processed transcript, including UTRs (introns spliced out)
 </tr>
 <tr>
        <td><i><b>genomic</b></i>
        <td>a region of the genome.  <i>Genomic sequence is always returned from 5' to 3', on the proper strand</i>
 </tr>
 </table>

<br>
Regions:
 <table width="100%" cellpadding="4">
   <tr>
      <td><i><b>relative to sequence start</b></i>
      <td>to retrieve, eg, the 100 bp upstream genomic region, use "begin at <i>start</i> + -100  end at <i>start</i> + -1".
   <tr>
      <td><i><b>relative to sequence stop</b></i>
      <td>to retrieve, eg, the last 10 amino acids of a protein, use "begin at <i>stop</i> + -9  end at <i>stop</i> + 0".
    <tr>
      <td><i><b>relative to sequence start and stop</b></i>
      <td>to retrieve, eg, a CDS with the  first and last 10 basepairs excised, use: "begin at <i>start</i> + 10 end at <i>stop</i> + -10".
    </tr>
  </table>

<table>
<tr>
  <td valign="top" class="dottedLeftBorder"></td> 
</tr>
</table> 
 
<site:footer/>
