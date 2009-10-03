<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="projectId" value="${applicationScope.wdkModel.projectId}" />


 <c:choose>
   
    <c:when test="${projectId == 'EuPathDB'}">
	<c:choose>
		<c:when test="${partial == true}">
			<jsp:include page="/customPages/${projectId}/SageTagQuestions.SageTagByLocation.partial.jsp"/>
		</c:when>
		<c:otherwise>
			<jsp:include page="/customPages/${projectId}/SageTagQuestions.SageTagByLocation.jsp"/>
		</c:otherwise>
	</c:choose>
    </c:when>
    <c:otherwise>
	<jsp:include page="/customPages/customQuestion.jsp"/>
    </c:otherwise>

  </c:choose>


	



