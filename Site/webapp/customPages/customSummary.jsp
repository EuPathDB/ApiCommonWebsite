<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>

<c:set var="wdkAnswer" value="${requestScope.wdkAnswer}"/>
<c:set var="history" value="${requestScope.wdkHistory}"/>
<c:set var="model" value="${applicationScope.wdkModel}" />
<c:set var="protocol" value="${requestScope.wdkProtocol}" />

<c:set var="type" value="None" />
<c:choose>
	<c:when test="${wdkAnswer.recordClass.fullName == 'GeneRecordClasses.GeneRecordClass'}">
		<c:set var="type" value="Gene" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'SequenceRecordClasses.SequenceRecordClass'}">
		<c:set var="type" value="Sequence" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'EstRecordClasses.EstRecordClass'}">
		<c:set var="type" value="EST" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'OrfRecordClasses.OrfRecordClass'}">
		<c:set var="type" value="ORF" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'SnpRecordClasses.SnpRecordClass'}">
		<c:set var="type" value="SNP" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'AssemblyRecordClasses.AssemblyRecordClass'}">
		<c:set var="type" value="Assembly" />
	</c:when>
	<c:when test="${wdkAnswer.recordClass.fullName == 'IsolateRecordClasses.IsolateRecordClass'}">
		<c:set var="type" value="Isolate" />
	</c:when>	
</c:choose>

<site:home_header refer="customSummary" />
<site:menubar />

<div id="contentwrapper">
  	<div id="contentcolumn2">
		<div class="innertube">
	  		<h1>${type} Results</h1>
			<input type="hidden" id="history_id" value="${history.historyId}"/>
			<hr>
		 	<site:BreadCrumbs history="${history}" wdkAnswer="${wdkAnswer}" model="${model}" recordClass="${wdkAnswer.recordClass}" protocol="${protocol}"/>
			<hr>
			<site:Results />
		</div>
	</div>
</div>
<site:footer />