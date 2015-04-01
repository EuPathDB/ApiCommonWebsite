<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<c:set var="project" value="${wdkModel.displayName}"/>

<%-- QUESTIONS --%>
<c:set var="questions" value="SnpQuestions.SnpsByIsolatePattern,SnpQuestions.HtsSnpsByIsolateComparison"/>

<!-- show error messages, if any -->
<div class='usererror'><api:errors/></div>

<%-- div needed for Add Step --%>
<div>

<center><table width="90%">

<c:set value="2" var="columns"/>

<tr class="headerRow"><td colspan="${columns + 2}" align="center"><b>Choose a Search</b><br><i style="font-size:80%">Mouse over to read description</i></td></tr>

<c:choose>
<c:when test = "${project == 'EuPathDB'}">
	<imp:queryList columns="${columns}" questions="${questions}"/>
</c:when>
<c:when test = "${project == 'ToxoDB' || project == 'PlasmoDB' || project == 'CryptoDB'}">
	<imp:queryList columns="${columns}" questions="${questions}"/>
</c:when>
</c:choose>

</table>
</center>
</div>


