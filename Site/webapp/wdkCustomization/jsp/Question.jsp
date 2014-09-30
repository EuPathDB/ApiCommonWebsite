<%@ page contentType="text/html; charset=ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<%-- partial is used for internal questions in queryList.tag --%>
<c:choose>
  <c:when test="${requestScope.partial != 'true'}">
    <imp:pageFrame title="Search for ${wdkQuestion.recordClass.displayNamePlural} by ${wdkQuestion.displayName}" refer="question">
      <imp:questionPageContent/>
    </imp:pageFrame>
    <!-- log screen and browser window size for awstats; excluded when page is called by Ajax (internal
       questions; partial == true)  because it breaks IE7. When using internal questions, the parent 
       question page will still call this once.
    -->
    <imp:script src="js/awstats_misc_tracker.js"/>
    <noscript><imp:image src="js/awstats_misc_tracker.js?nojs=y" height="0" width="0" border="0" style="display: none"/></noscript>
  </c:when>
  <c:otherwise>
    <imp:questionPageContent/>
  </c:otherwise>
</c:choose>
