<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="nohelp"
              required="false"
              description="when set, no help icon is added"
%>


<%-- get wdkQuestion; setup requestScope HashMap to collect help info for footer --%>
<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
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
        <c:set var="recordType" value="Assemblie" />
</c:if>


<%-- show all params of question, collect help info along the way --%>
<c:set value="Help for question: ${wdkQuestion.displayName}" var="fromAnchorQ"/>
<jsp:useBean id="helpQ" class="java.util.LinkedHashMap"/>

<c:set var="hasOrganism" value="false"/>
<c:set value="${wdkQuestion.paramMapByGroups}" var="paramGroups"/>

<c:forEach items="${paramGroups}" var="paramGroupItem">
    <c:set var="group" value="${paramGroupItem.key}" />
    <c:set var="paramGroup" value="${paramGroupItem.value}" />
  
    <%-- determine starting display style by displayType of the group --%>
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
		<img  class="group-handle" src='<c:url value="/images/${image}" />' />
		<span>${groupName}</span>
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
            <%--<c:when test="${isHidden}"><html:hidden property="value(${qP.class.name})"/></c:when>--%>
            <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.TimestampParamBean'}">
                <wdk:timestampParamInput qp="${qP}" />
            </c:when>
            <c:when test="${isHidden}">
                <c:choose>
                   <c:when test="${fn:containsIgnoreCase(wdkModel.displayName,'EuPathDB')}">
                        <c:choose>
                           <c:when test="${pNam eq 'signature'}">
                            <html:hidden property="value(${pNam})" value="${wdkUser.signature}"/>
                           </c:when>
                           <c:otherwise>
                                <html:hidden property="value(${pNam})"/>
                           </c:otherwise>
                        </c:choose>
                   </c:when>
                   <c:otherwise>
                        <html:hidden property="value(${pNam})"/>
                   </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise> <%-- visible param --%>
                <%-- an individual param (can not use fullName, w/ '.', for mapped props) --%>
                <tr>
                    <td width="30%" align="right" style="vertical-align:top">
                        <b>
                            ${qP.prompt} <img id="help_${pNam}" class="help_link" rel="htmltooltip" src="wdk/images/question.png" />
                        </b>
                    </td>
                    <c:choose>
                        <c:when test="${fn:containsIgnoreCase(pNam,'organislm') && wdkModel.displayName eq 'EuPathDB'}">

<c:choose>
<c:when test="${fn:contains(wdkQuestion.name, 'Location') || fn:contains(wdkQuestion.name, 'Snp') }">  <!-- as it happens in component sites  under choice below EnumParamBean -->

                            <td align="left" style="vertical-align:bottom" id="${qP.name}aaa">
                                <wdk:enumParamInput qp="${qP}" />
                            </td>
                           
</c:when>
<c:otherwise>

                            <c:set var="hasOrganism" value="true"/>
                            <td width="300" align="left" valign="top" rowspan="${paramCount}" cellpadding="5">
                                <table border="5">
                                    <tr>
                                    <td ><b>${qP.prompt}&nbsp;&nbsp;&nbsp;</b>
                                    <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                                    <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
                                        <%-- <site:cardsOrgansimParamInput qp="${qP}" portals="${portalsProp}" /> --%>
                                        <wdk:enumParamInput qp="${qP}" />
                                    </td>
                                    </tr>
                                </table>
                             </td>
                             <td valign="top" align="center">
			         <table border="0">

</c:otherwise>
</c:choose>
                        </c:when>
                        
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.EnumParamBean'}">
                            <td align="left" style="vertical-align:bottom" id="${qP.name}aaa">
                                <wdk:enumParamInput qp="${qP}" />
                            </td>
                        </c:when>
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.AnswerParamBean'}">
                            <td align="left" valign="top">
                                <wdk:answerParamInput qp="${qP}" />
                            </td>
                        </c:when>
                        <c:when test="${qP.class.name eq 'org.gusdb.wdk.model.jspwrap.DatasetParamBean'}">
                            <td align="left" valign="top">
                                <wdk:datasetParamInput qp="${qP}" />
                            </td>
                        </c:when>
                                <c:when test="${isReadonly}">
                                    <td align="left" valign="top">
                                        <bean:write name="qForm" property="value(${pNam})"/>
                                        <html:hidden property="value(${pNam})"/>
                                    </td>
                                </c:when>
                                <c:otherwise>

                                    <td align="left" valign="top">
                                        <html:text styleId="${pNam}" property="value(${pNam})" size="35" />
                                    </td>
                                </c:otherwise>
                    </c:choose>

                    <c:if test="${!fn:containsIgnoreCase(pNam,'organism')}">
                      <%--   <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;</td> --%>
                        <td valign="top" width="50" nowrap>
                            <c:set var="anchorQp" value="HELP_${fromAnchorQ}_${pNam}"/>
                            <c:set target="${helpQ}" property="${anchorQp}" value="${qP}"/>
			 <c:if test="!${nohelp eq 'true'}">
                            <a id="help_${pNam}" class="help_link" href="#" rel="htmltooltip">
                            	<img src="/assets/images/help.png" border="0" alt="Help">
    			    </a>
			 </c:if>
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
                	        <div class="htmltooltip" id="help_${pNam}_tip">${qP.help}</div>
                </c:if>
            
        </c:forEach>
    
        </div> <%-- end of group-detail div --%>
    </div> <%-- end of param-group div --%>

</c:forEach> <%-- end of foreach on paramGroups --%>


<wdk:weight wdkModel="${wdkModel}" wdkQuestion="${wdkQuestion}" />


<%-- set the custom name --%>
<div name="All_weighting" class="param-group" type="ShowHide">
	  <c:set var="display" value="none"/>
  <c:set var="image" value="plus.gif"/>
  <div class="group-title">
	 <img class="group-handle" src='<c:url value="wdk/images/${image}" />'/>
   	 <span title="This name will be the name of the step.">Give this search a name</span>
  </div>
  <div class="group-detail" style="display:${display};text-align:center">
    <div class="group-description">
      <p><html:text property="customName" maxlength="15" value="${customName}" />  </p>
    </div><br>
  </div>
</div>

