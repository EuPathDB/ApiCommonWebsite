<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<c:set var="recordType" value="${wdkQuestion.recordClass.type}"/>
<c:set var="projectId" value="${applicationScope.wdkModel.projectId}" />


 <c:choose>
    <c:when test="${projectId == 'CryptoDB' || projectId == 'GiardiaDB' || projectId == 'ToxoDB' || projectId == 'TriTrypDB' || projectId == 'TrichDB'}">
        <jsp:forward page="/showQuestion.do?questionFullName=GeneQuestions.GenesByMassSpec" /> 
    </c:when>

    <c:otherwise>


${Question_Header}
<wdk:errors/>

<%-- div needed for Add Step --%>
<div id="form_question">
<h1>Identify ${recordType}s based on ${wdkQuestion.displayName}</h1>
<table width="100%">
<c:set value="1" var="columns"/>

<tr class="headerRow"><td colspan="${columns +2 }" align="center"><b>Choose a Search</b><br><i style="font-size:80%">Mouse over to read description</i></td></tr>

	<site:queryList3 columns="${columns}" questions="GeneQuestions.GenesByMassSpec,GeneQuestions.GenesByProteomicsProfile"/>

</table>
</div>
    </c:otherwise>

</c:choose>

${Question_Footer}
