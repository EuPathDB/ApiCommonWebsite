<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="projectId" value="${applicationScope.wdkModel.projectId}" />


 <c:choose>
   
    <c:when test="${projectId == 'EuPathDB'}">
	<jsp:include page="/customPages/${projectId}/GeneQuestions.GenesBySnps.jsp"/>
    </c:when>
    <c:otherwise>
	<jsp:forward page="/showQuestion.do?questionFullName=GeneQuestions.GenesBySnps" /> 
    </c:otherwise>

  </c:choose>






