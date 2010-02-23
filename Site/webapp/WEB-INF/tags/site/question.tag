<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="api" uri="http://apidb.org/taglib" %>

${Question_Header}

<link rel="stylesheet" href="<c:url value='/misc/Top_menu.css' />" type="text/css">


<%-- get wdkQuestion; setup requestScope HashMap to collect help info for footer --%>
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<jsp:useBean scope="request" id="helps" class="java.util.LinkedHashMap"/>
<c:set var="qForm" value="${requestScope.questionForm}"/>
<%-- display page header with wdkQuestion displayName as banner --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />
<c:set var="recordType" value="${wdkQuestion.recordClass.type}"/>
<c:set var="showParams" value="${requestScope.showParams}"/>

<%--CODE TO SET UP THE SITE VARIABLES --%>
<c:if test="${wdkModel.displayName eq 'EuPathDB'}">
    <c:set var="portalsProp" value="${props['PORTALS']}" />
</c:if>
<c:if test="${fn:contains(recordType, 'Assem') }">
        <c:set var="recordType" value="Transcript Assemblie" />
</c:if>

<%-- show all params of question, collect help info along the way --%>
<c:set value="Help for question: ${wdkQuestion.displayName}" var="fromAnchorQ"/>
<jsp:useBean id="helpQ" class="java.util.LinkedHashMap"/>

<c:choose>
    <c:when test="${showParams == true}">
        <%-- display params section only --%>
        <html:form styleId="form_question" method="post" enctype='multipart/form-data' action="/processQuestion.do">
            <input type="hidden" name="questionFullName" value="${wdkQuestion.fullName}"/>
            <site:questionParams />
        </html:form>
    </c:when>
    <c:otherwise>
        <%-- display question section --%>


<h1>Identify ${recordType}s based on ${wdkQuestion.displayName}</h1>
<table border=0 width=100% cellpadding=3 cellspacing=0 bgcolor=white class=thinTopBorders> 

 <tr>
  <td bgcolor=white valign=top>

<%-- put an anchor here for linking back from help sections --%>
<A name="${fromAnchorQ}"></A>
<!--html:form method="get" action="/processQuestion.do" -->
<html:form styleId="form_question" method="post" enctype='multipart/form-data' action="/processQuestion.do">
<input type="hidden" name="questionFullName" value="${wdkQuestion.fullName}"/>

<%--
<c:if test="${wdkQuestion.fullName == 'GeneQuestions.GenesByLocation'}">
	<script src="/assets/js/LocationSelector.js"></script>
</c:if>
--%>

<!-- show error messages, if any -->
<api:errors/>

<%-- the js has to be included here in order to appear in the step form --%>
<script type="text/javascript" src='<c:url value="/wdk/js/wdkQuestion.js"/>'></script>
<c:if test="${showParams == null}">
            <script type="text/javascript">
              $(document).ready(function() { initParamHandlers(); });
            </script>
</c:if>

<div class="params">

<%-- enter from original question page, display params here 
<c:if test="${showParams == null}">
    <site:questionParams />
</c:if>
--%>

<c:if test="${showParams == null}">
<%--CODE TO SET UP THE SITE VARIABLES --%>
<c:if test="${wdkModel.displayName eq 'EuPathDB'}">
    <c:set var="portalsProp" value="${props['PORTALS']}" />
</c:if>
<c:if test="${fn:contains(recordType, 'Assem') }">
        <c:set var="recordType" value="Assemblie" />
</c:if>



<c:set var="hasOrganism" value="false"/>
<c:set value="${wdkQuestion.paramMapByGroups}" var="paramGroups"/>

<c:forEach items="${paramGroups}" var="paramGroupItem">
    <c:set var="group" value="${paramGroupItem.key}" />
    <c:set var="paramGroup" value="${paramGroupItem.value}" />
  
    <%-- detemine starting display style by displayType of the group --%>
    <c:set var="groupName" value="${group.displayName}" />
    <c:set var="displayType" value="${group.displayType}" />
    <div name="${wdkQuestion.name}_${group.name}"
         class="param-group" 
         type="${displayType}">
    <c:choose>
        <c:when test="${displayType eq 'empty'}">
            <%-- output nothing else --%> 
            <div class="group-detail">
        </c:when>
        <c:when test="${displayType eq 'ShowHide'}">
            <c:set var="display">
                <c:choose>
                    <c:when test="${group.visible}">block</c:when>
                    <c:otherwise>none</c:otherwise>
                </c:choose>
            </c:set>
            <c:set var="image">
                <c:choose>
                    <c:when test="${group.visible}">minus.gif</c:when>
                    <c:otherwise>plus.gif</c:otherwise>
                </c:choose>
            </c:set>
            <div class="group-title">
                <img style="position:relative;top:5px;" class="group-handle" src='<c:url value="/images/${image}" />' />
                ${groupName}
            </div>
            <div class="group-detail" style="display:${display};">
                <div class="group-description">${group.description}</div>
        </c:when>
        <c:otherwise>
            <div class="group-title">${groupName}</div>
            <div class="group-detail">
                <div class="group-description">${group.description}</div>
        </c:otherwise>
    </c:choose>
    
    <table border="0" width="100%">
    
    <c:set var="paramCount" value="${fn:length(paramGroup)}"/>
    <%-- display parameter list --%>
    <c:forEach items="${paramGroup}" var="paramItem">
        <c:set var="pNam" value="${paramItem.key}" />
        <c:set var="qP" value="${paramItem.value}" />
        
        <c:set var="isHidden" value="${qP.isVisible == false}"/>
        <c:set var="isReadonly" value="${qP.isReadonly == true}"/>
  
        <%-- hide invisible params --%>
        <c:choose>
            <%--<c:when test="${isHidden}"><html:hidden property="myProp(${qP.class.name})"/></c:when>--%>
            <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.TimestampParamBean'}">
                <wdk:timestampParamInput qp="${qP}" />
            </c:when>
            <c:when test="${isHidden}">
                <c:choose>
                   <c:when test="${fn:containsIgnoreCase(wdkModel.displayName,'EuPathDB')}">
                        <c:choose>
                           <c:when test="${pNam eq 'signature'}">
                            <html:hidden property="myProp(${pNam})" value="${wdkUser.signature}"/>
                           </c:when>
                           <c:otherwise>
                                <html:hidden property="myProp(${pNam})"/>
                           </c:otherwise>
                        </c:choose>
                   </c:when>
                   <c:otherwise>
                        <html:hidden property="myProp(${pNam})"/>
                   </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise> <%-- visible param --%>
                <%-- an individual param (can not use fullName, w/ '.', for mapped props) --%>
                <tr>
                    <c:choose>
                        <c:when test="${fn:containsIgnoreCase(pNam,'organism') && wdkModel.displayName eq 'EuPathDB'}">
                            <c:set var="hasOrganism" value="true"/>
                            <td width="300" align="left" valign="top" rowspan="${paramCount}" cellpadding="5">
                                <table border="0">
                                    <tr>
                                    <td ><b>${qP.prompt}&nbsp;&nbsp;&nbsp;</b>
                                    <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                                    <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
<%--
                                    <a href="#${anchorQp}">
                                    <img valign="bottom" src="/assets/images/help.png" border="0" alt="Help"></a><br>
--%>
                                    <site:cardsOrgansimParamInput qp="${qP}" portals="${portalsProp}" />
                                    </td>
                                    </tr>
                                </table>
                             </td>
                             <td valign="top" align="center">
			         <table border="0">
                        </c:when>

                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.EnumParamBean'}">
                            <td width="30%" align="right" style="vertical-align:top">
<%--
					<c:if test="${wdkQuestion.fullName == 'GeneQuestions.GenesByLocation' && pNam == 'organism'}">
						<input type="hidden" name="holder" id="organism_holder" value=""/>
						<input type="hidden" name="holder" id="chromosomeOptional_holder" value=""/>
						<input id="${pNam}_radio" type="radio" name="location_radio" onclick="changeType('${pNam}')"/>
					</c:if>
--%>
					<b id="help_${pNam}" class="help_link" rel="htmltooltip">${qP.prompt}</b>
			    </td>
                            <td align="left" style="vertical-align:bottom" id="${qP.name}aaa">
                                <wdk:enumParamInput qp="${qP}" />
                            </td>
                        </c:when>

                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.HistoryParamBean'}">
                            <td width="30%" align="right" valign="top"><b id="help_${pNam}" class="help_link" rel="htmltooltip">${qP.prompt}</b></td>
                            <td align="left" valign="top">
                                <wdk:answerParamInput qp="${qP}" />
                            </td>
                        </c:when>

                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.DatasetParamBean'}">
                            <td width="30%" align="right" valign="top"><b id="help_${pNam}" class="help_link" rel="htmltooltip">${qP.prompt}</b></td>
                            <td align="left" valign="top">
                                <wdk:datasetParamInput qp="${qP}" />
                            </td>
                        </c:when>

                        <c:otherwise>  <%-- not enumParam --%>
                            <c:choose>
                                <c:when test="${isReadonly}">
                                    <td width="30%" align="right" valign="top"><b id="help_${pNam}" class="help_link" rel="htmltooltip">${qP.prompt}</b></td>
                                    <td align="left" valign="top">
                                        <bean:write name="qForm" property="myProp(${pNam})"/>
                                        <html:hidden property="myProp(${pNam})"/>
                                    </td>
                                </c:when>
                                <c:otherwise>
									
                                    <td width="30%" align="right" valign="top">
<%--
					<c:if test="${wdkQuestion.fullName == 'GeneQuestions.GenesByLocation' && pNam == 'sequenceId'}">
						<input id="${pNam}_radio" type="radio" name="location_radio" onclick="changeType('${pNam}')"/>
					</c:if>
--%>
					<b id="help_${pNam}" class="help_link" rel="htmltooltip">${qP.prompt}</b>
				    </td>
                                    <td align="left" valign="top">
                                        <html:text styleId="${pNam}" property="myProp(${pNam})" size="35" />
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${!fn:containsIgnoreCase(pNam,'organism')}">
                        <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td valign="top" width="50" nowrap>
                            <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                            <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
                            <a id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">
                            	<img src="/assets/images/help.png" border="0" alt="Help">
    						</a>
                        </td>
                    </c:if>
                </tr>
            </c:otherwise> <%-- end visible param --%>
        </c:choose>
        
        </c:forEach> <%-- end of forEach params --%>
        
        <%-- detemine ending display style by displayType of the group --%>
        <c:if test="${hasOrganism}"></table></c:if>
        </table>
    
        <%-- prepare the help info --%>
        <c:forEach items="${paramGroup}" var="paramItem">
            <c:set var="pNam" value="${paramItem.key}" />
            <c:set var="qP" value="${paramItem.value}" />
            
            <c:set var="isHidden" value="${qP.isVisible == false}"/>
            <c:set var="isReadonly" value="${qP.isReadonly == true}"/>
    
                <c:if test="${!isHidden}">
                        <c:if test="${!fn:containsIgnoreCase(pNam,'organism')}">
                	        <div class="htmltooltip" id="help_${pNam}_tip">${qP.help}</div>
                        </c:if>
                </c:if>
            
        </c:forEach>
    
        </div> <%-- end of group-detail div --%>
    </div> <%-- end of param-group div --%>

</c:forEach> <%-- end of foreach on paramGroups --%>

<%-- set the weight --%>

<div name="All_weighting"
     class="param-group" 
     type="ShowHide">
<c:set var="display" value="none"/>
<c:set var="image" value="plus.gif"/>
<div class="group-title">
    <img style="position:relative;top:5px;"  class="group-handle" src='<c:url value="/images/${image}" />' />
    Give this search a weight
</div>
<div class="group-detail" style="display:${display};text-align:center">
    <div class="group-description">
	<p><input type="text" name="weight" value="0">  </p> 
	<p>Optionally give this search a "weight" (for example 10, 200, -50).<br>In a search strategy, unions and intersects will sum the weights, giving higher scores to items found in multiple searches. </p>
	
    </div><br>
</div>
</div>


</c:if>



</div> <%-- end of params div --%>

<c:set target="${helps}" property="${fromAnchorQ}" value="${helpQ}"/>






<div class="filter-button"><html:submit property="questionSubmit" value="Get Answer"/></div>

<%--
<c:if test="${wdkQuestion.fullName == 'GeneQuestions.GenesByLocation'}">
<script>
	$("input#organism_radio").click();
</script>
</c:if>
--%>

</html:form>


<hr>

<c:set var="attrId" value="attributions-section"/>
<c:set var="descripId" value="query-description-section"/>
<c:if test="${wdkQuestion.fullName == 'IsolateQuestions.IsolateByCountry'}">
	<c:set var="descripId" value="query-description-noShowOnForm"/>
</c:if>


<%-- display description for wdkQuestion --%>
<div id="${descripId}"><b>Query description: </b><jsp:getProperty name="wdkQuestion" property="description"/></div>


<%-- get the attributions of the question if not EuPathDB --%>
<c:if test = "${project != 'EuPathDB'}">
<hr>
<div id="${attrId}">
	<c:set var="propertyLists" value="${wdkQuestion.propertyLists}"/>
	<site:attributions attributions="${propertyLists['specificAttribution']}" caption="Data sources" />
</div>
</c:if>


</tr>
</table> 

    </c:otherwise> <%-- otherwise of showParams == true --%>
</c:choose>

${Question_Footer}
