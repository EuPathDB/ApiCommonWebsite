<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="project" value="${applicationScope.wdkModel.name}" />
<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>

<c:choose>
<c:when test="${wdkUser.historyCount == null}">
<c:set var="count" value="0"/>
</c:when>
<c:otherwise>
<c:set var="count" value="${wdkUser.historyCount}"/>
</c:otherwise>
</c:choose>



<div id="menubar">
<div id="menu">

<ul>
	<li><a href="<c:url value="/"/>">Home</a>
	</li>
	</ul>
	<ul>
	<li><a href="<c:url value="/queries_tools.jsp"/>">New Search</a>
  	<site:drop_down_QG />
	</li>
	</ul>
	<ul>
	<li><a href="<c:url value="/showQueryHistory.do"/>"><div id="mysearch">My Searches: ${count}</div></a>
	</li>
	</ul>
	<ul>
	<li><a href="#">Tools</a>
		<ul>
			<li><a href="<c:url value="/showQuestion.do?questionFullName=UniversalQuestions.UnifiedBlast"/>"> BLAST</a></li>
  			<li><a href="<c:url value="/srt.jsp"/>"> Sequence Retrieval</a></li>
        	<li><a href="/common/PubCrawler/"> PubMed and Entrez</a></li>
        	<li><a href="/cgi-bin/gbrowse/"> GBrowse</a></li>
        	<c:if test="${project != 'TriTrypDB' && 
        	              project != 'GiardiaDB' && 
        	              project != 'TrichDB'}">
            	<li><a href="http://apicyc.apidb.org">ApiCyc</a></li>
        	</c:if>
    	</ul>
	</li>
	</ul>
	<ul>
	<li><a href="#">Data Sources</a>
  		<ul>
   			 <li><a href="<c:url value='showXmlDataContent.do?name=XmlQuestions.DataSources'/>">Data Detail</a></li>
 	    		<li><a href="#">Analysis Methods</a></li>
<%--
   		<li><a href="#">Data Statistics</a></li>
                <li><a href="#">Standard Operating Procedures (SOPs)</a></li>
--%>
  		</ul>
	</li>
	</ul>
	<ul>
	<li><a href="#">Download Files</a>

		<ul>
    		<li><a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.About#download"/>">Understanding Downloads</a></li>
    		<li><a href="/common/downloads">Data Files</a></li>
    		<li><a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.About#doc-prot"/>">Documents and Publications</a></li> 
    		<li><a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.About#doc-prot"/>">Protocols and Methods</a></li>
<%-- 
    		<li><a href="#">Experimental Data</a></li>
--%>

   
  		</ul>
	</li>
</ul>
</div>
</div><a name="skip" id="skip"></a>
