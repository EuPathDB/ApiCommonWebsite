<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set value="${wdkModel.displayName}" var="project"/>
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<c:set var="recordType" value="${wdkQuestion.recordClass.type}"/>

<c:set value="1" var="columns"/>

<!-- show error messages, if any -->
<div class='usererror'><api:errors/></div>

<%-- div needed for Add Step --%>
<div id="form_question">

<table width="100%" cellpadding="4">
<tr class="headerRow"><td colspan="${columns + 2}" align="center"><b>Choose a Search</b><br><i style="font-size:80%">Mouse over to read description</i></td></tr>

<site:queryList3  columns="${columns}" questions="GeneQuestions.GenesBySageTag,GeneQuestions.GenesBySageTagRStat"/>

</table>
</div>


