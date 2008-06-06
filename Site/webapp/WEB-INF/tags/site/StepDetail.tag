<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>

<%@ attribute name="step"
	      type="org.gusdb.wdk.model.jspwrap.StepBean"
              required="true"
              description="Step to be displayed by this tag"
%>

<%@ attribute name="protocolNum"
	      type="java.lang.String"
              required="true"
              description="Protocol Including this Step"
%>

<%@ attribute name="stepNum"
	      type="java.lang.String"
              required="true"
              description="Number of this step in the protocol"
%>

<c:choose>
<c:when test="${step.isFirstStep}">
<c:set value="${step.filterHistory.answer.question.fullName}" var="questionName" />
<c:set value="${step.filterHistory.answer.question.displayName}" var="displayName"/>
<c:set value="${step.filterHistory.answer.params}" var="displayParams"/>
<c:set value="${step.filterHistory.answer.questionUrlParams}" var="urlParams"/>
</c:when>
<c:otherwise>
<c:set value="${step.subQueryHistory.answer.question.fullName}" var="questionName" />
<c:set value="${step.subQueryHistory.answer.question.displayName}" var="displayName"/>
<c:set value="${step.subQueryHistory.answer.params}" var="displayParams"/>
<c:set value="${step.subQueryHistory.answer.questionUrlParams}" var="urlParams"/>
</c:otherwise>
</c:choose>

<c:set var="subq" value="" />
  <div class="crumb_details" onmouseover="overdiv=1" onmouseout="overdiv=0; setTimeout('hideDetails()',50)">
	<p class="question_name">Details&nbsp;for:&nbsp;<span>${displayName}</span></p>
	<table style="margin: 0 5px;">
	<c:forEach var="displayParam" items="${displayParams}">
	     <tr class="param">
                <td align="right" nowrap class="name">${displayParam.key}&nbsp;=</td>
		<td align="left" nowrap>&nbsp;${displayParam.value}</td>
             </tr>
        </c:forEach>
	</table>
   <c:choose>
      <c:when test="${step.isFirstStep}">
          <p><b>Results:&nbsp;</b>${step.filterResultSize}</p>
      </c:when>
      <c:otherwise>
          <p><b>Query Results:&nbsp;</b>${step.subQueryResultSize}</p>
	  <c:set var="subq" value="&subquery=true" />
      </c:otherwise>
   </c:choose>
   <div class="crumb_menu">
		<a href="showSummary.do?protocol=${protocolNum}&step=${stepNum}${subq}">view</a>&nbsp;|&nbsp;
		<a class="edit_step_link" href="showQuestion.do?questionFullName=${questionName}${urlParams}&questionSubmit=Get+Answer&goto_summary=0" id="${stepNum}">edit</a>&nbsp;|&nbsp;
		<span style="color:#888;">delete</span>
   </div>       
  </div><!--End Crumb_Detail-->
