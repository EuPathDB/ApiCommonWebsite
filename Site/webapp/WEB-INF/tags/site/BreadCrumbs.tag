

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>


<%@ attribute name="history"
	      type="org.gusdb.wdk.model.jspwrap.HistoryBean"
              required="false"
              description="history object for this question"
%>

<%@ attribute name="wdkAnswer"
	      type="org.gusdb.wdk.model.jspwrap.AnswerBean"
              required="false"
              description="Answer object for this question"
%>

<%@ attribute name="model"
	      type="org.gusdb.wdk.model.jspwrap.WdkModelBean"
              required="false"
              description="Wdk Model Object for this site"
%>

<%@ attribute name="recordClass"
	      type="org.gusdb.wdk.model.jspwrap.RecordClassBean"
              required="false"
              description="RecordClass Object for the Answer"
%>

<%@ attribute name="protocol"
	      type="org.gusdb.wdk.model.jspwrap.ProtocolBean"
              required="false"
              description="Protocol from the SummaryPage"
%>

<script type="text/javascript" src="js/lib/jquery-1.2.3.js"></script>
<script type="text/javascript" src="js/filter_menu.js"></script>
<link rel="StyleSheet" href="misc/filter_menu.css" type="text/css"/>
<c:set var="stepNumber" value="0" />
<div id="bread_crumb_div">
  <table><tr>

<c:set var="steps" value="${protocol.allSteps}" />
<c:forEach items="${steps}" var="step">

  <td>

  <c:choose>
     <c:when test="${step.isFirstStep}">
        <div class="crumb"><a class="crumb_name" href="showSummary.do?protocol=${protocol.protocolId}&step=${stepNumber}">${step.customName}</a>
     </c:when>
     <c:otherwise>
        <div class="operation"><b>${step.operation}</b></div></td>
        <td><div class="crumb"><a class="crumb_name" href="showSummary.do?protocol=${protocol.protocolId}&step=${stepNumber}">${step.customName}</a>
     </c:otherwise>
  </c:choose>

   <div class="crumb_details">
	
    <p><b>Details:&nbsp;</b><pre>${step.details}</pre></p>

    <c:choose>
       <c:when test="${step.isFirstStep}">
           <p><b>Results:&nbsp;</b>${step.filterResultSize}</p>
       </c:when>
       <c:otherwise>
           <p><b>Results:&nbsp;</b>${step.filterResultSize}</p>
           <p><b>Query Results:&nbsp;</b>${step.subQueryResultSize}</p>
       </c:otherwise>
    </c:choose>
          
	  <!-- a section to display/hide params -->
          <!-- <div id="showParamArea" style="background:#EEEEEE;">
             < c:choose>
                 <c:when test="${wdkAnswer.isBoolean}">
                        <div>
                                <%-- boolean question --%>
                                <nested:root name="wdkAnswer">
                                    <jsp:include page="/WEB-INF/includes/bqShowNode.jsp"/>
                                </nested:root>
	                        </div>
                        </c:when>
                        <c:otherwise>
                            <wdk:showParams wdkAnswer="${wdkAnswer}" />
                        </c:otherwise>
              </c:choose>
             </div>
    
    <!-- display result size -->
    <b>Results:&nbsp; </b>
          ${wdkAnswer.resultSize}

 <c:if test="${wdkAnswer.resultSize == 0}">
              <c:if test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
                 <site:apidbSummary/>
             </c:if>
   </c:if>

          <c:if test="${wdkAnswer.resultSize > 0}">
             (showing ${wdk_paging_start} to ${wdk_paging_end})
              <c:if test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
                 <site:apidbSummary/>
             </c:if>
          </c:if> -->
           
   </div><!--End Crumb_Detail-->
 </div><!-- End Crumb -->
</td>
<c:set var="stepNumber" value="${stepNumber+1}" />
</c:forEach>
<td><b>&gt;</b></td>
<td>
<div id="filter_link_div">
<site:FilterInterface model="${model}" recordClass="${recordClass}" protocol="${protocol}"/>
</div>
</td></tr></table>

</div><!-- End Bread_Crumb_Div -->

