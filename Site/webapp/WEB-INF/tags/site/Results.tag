<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>

<c:set var="wdkAnswer" value="${requestScope.wdkAnswer}"/>
<c:set var="qName" value="${wdkAnswer.question.fullName}" />
<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="cryptoIsolatesQuestion" value="${fn:containsIgnoreCase(qName, 'Isolate') && fn:containsIgnoreCase(modelName, 'CryptoDB')}" />

<%-- When implement visualizing multiple strategies, the name of the strategy (for the title) could cme from the step object probably --%>

<%@ attribute name="strategy"
			  type="org.gusdb.wdk.model.jspwrap.StrategyBean"
              required="true"
              description="Strategy Id we are looking at"
%>
<c:set var="type" value="Results" />
<c:set var="step_dataType" value="${strategy.latestStep.dataType}" />
<c:choose>
	<c:when test="${step_dataType == 'GeneRecordClasses.GeneRecordClass'}">
		<c:set var="type" value="Genes" />
	</c:when>
	<c:when test="${step_dataType == 'SequenceRecordClasses.SequenceRecordClass'}">
		<c:set var="type" value="Sequences" />
	</c:when>
	<c:when test="${step_dataType == 'EstRecordClasses.EstRecordClass'}">
		<c:set var="type" value="EST" />
	</c:when>
	<c:when test="${step_dataType == 'OrfRecordClasses.OrfRecordClass'}">
		<c:set var="type" value="ORF" />
	</c:when>
	<c:when test="${step_dataType == 'SnpRecordClasses.SnpRecordClass'}">
		<c:set var="type" value="SNP" />
	</c:when>
	<c:when test="${step_dataType == 'AssemblyRecordClasses.AssemblyRecordClass'}">
		<c:set var="type" value="Assemblies" />
	</c:when>
	<c:when test="${step_dataType == 'IsolateRecordClasses.IsolateRecordClass'}">
		<c:set var="type" value="Isolates" />
	</c:when>	
</c:choose>

<c:set var="qsp" value="${fn:split(wdk_query_string,'&')}" />
<c:set var="commandUrl" value="" />
<c:forEach items="${qsp}" var="prm">
  <c:if test="${fn:split(prm, '=')[0] eq 'strategy'}">
    <c:set var="commandUrl" value="${commandUrl}${prm}&" />
  </c:if>
  <c:if test="${fn:split(prm, '=')[0] eq 'step'}">
    <c:set var="commandUrl" value="${commandUrl}${prm}&" />
  </c:if>
  <c:if test="${fn:split(prm, '=')[0] eq 'subquery'}">
    <c:set var="commandUrl" value="${commandUrl}${prm}&" />
  </c:if>
  <c:if test="${fn:split(prm, '=')[0] eq 'summary'}">
    <c:set var="commandUrl" value="${commandUrl}${prm}&" />
  </c:if>
</c:forEach>
<c:set var="commandUrl"><c:url value="/processSummary.do?${commandUrl}" /></c:set>

<wdk:filterLayouts strategyId="${strategy.strategyId}" 
                   stepId="${wdkHistory.stepId}"
                   answerValue="${wdkAnswer}" />


<!-- handle empty result set situation -->
<c:choose>
  <c:when test='${wdkAnswer.resultSize == 0}'>
    No results for your query
  </c:when>
  <c:otherwise>


<table width="100%"><tr>
<td style="padding-top:6px;"><h2 style="display:none"><span id="text_strategy_number">${strategy.name}</span> 
    (step <span id="text_step_number">${strategy.length}</span>) 
    - ${wdkAnswer.resultSize} <span id="text_data_type">${type}</span></h2></td>
<td align="right" style="vertical-align:middle"><a href="downloadStep.do?step_id=${wdkHistory.stepId}"><b>DOWNLOAD RESULT&nbsp;&nbsp;&nbsp;&nbsp;</b></a></td>
</tr></table>


<!-- pager -->
<pg:pager isOffset="true"
          scope="request"
          items="${wdk_paging_total}"
          maxItems="${wdk_paging_total}"
          url="${wdk_paging_url}"
          maxPageItems="${wdk_paging_pageSize}"
          export="currentPageNumber=pageNumber">
  <c:forEach var="paramName" items="${wdk_paging_params}">
    <pg:param name="${paramName}" id="pager" />
  </c:forEach>
  <c:if test="${wdk_summary_checksum != null}">
    <pg:param name="summary" id="pager" />
  </c:if>
  <c:if test="${wdk_sorting_checksum != null}">
    <pg:param name="sort" id="pager" />
  </c:if>

<div id="primaryKey_div" style="display:none">
<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr><td valign="top" width="75px" style="background-color: #DDDDDD">
<site:IdList />
</td><td valign="top" >

<div id="Record_Page_Div" style="display: none">
<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<c:set value="${wdkAnswer.summaryAttributes[0]}" var="sumAttrib"/>
	<c:set var="attrName" value="${sumAttrib.name}" />
	<tr class="subheaderrow">
   		<th align="center" valign="middle">
      		${sumAttrib.displayName} Record Page
    	</th>
	</tr>


	<tr class="headerrow">
   		<th align="center" valign="middle">
      		<span id="record_cell_header" style="font-size: 18px;" >Gene ID </span>
    	</th>
	</tr>
	<tr><td><div id="record_page_cell_div"></div></td></tr>
</table>
</div>

</td></tr>
</table>
</div>
<div id="Results_Pane" style="display: block">
<table width="100%" border="0" cellpadding="3" cellspacing="0">
	<tr class="subheaderrow">
<%--
			<th align="left">
			      <input id="summary_view_button" disabled="disabled" type="submit" value="Summary View" onclick="ToggleGenePageView('')" />
			</th>
--%>
			<th align="left" nowrap> 
		        <wdk:pager pager_id="top"/> 
		    </th>


			<th nowrap align="right">
		           <%-- display a list of sortable attributes --%>
		           <c:set var="addAttributes" value="${wdkAnswer.displayableAttributes}" />
		           <select id="addAttributes" onChange="addAttr('${commandUrl}')">
		               <option value="">--- Add Column ---</option>
		               <c:forEach items="${addAttributes}" var="attribute">
		                 <option value="${attribute.name}">${attribute.displayName}</option>
		               </c:forEach>
		           </select>
		    </th>
		    <th nowrap align="right" width="5%">
		         &nbsp;
		         <input type="button" value="Reset Columns" onClick="resetAttr('${commandUrl}')" />
		    </th>
	</tr>
</table>	
<c:if test = "${cryptoIsolatesQuestion}">
  <form name="checkHandleForm" method="post" action="/dosomething.jsp"> 
</c:if>
<!-- content of current page -->
<c:set var="sortingAttrNames" value="${wdkAnswer.sortingAttributeNames}" />
<c:set var="sortingAttrOrders" value="${wdkAnswer.sortingAttributeOrders}" />
<table id="Results_Table" width="100%" border="0" cellpadding="3" cellspacing="0">
<thead>
<tr class="headerrow">
  <c:set var="j" value="0"/>
  <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
    <c:set var="attrName" value="${sumAttrib.name}" />
    <th id="${attrName}" align="left" valign="middle">
      <%-- <div class="headercontents"> --%>
	<table>
          <tr>
            <td style="width:20px;min-height:20px;">
          <c:choose>
            <c:when test="${!sumAttrib.sortable}">
              <img style="float:left;" src="/assets/images/results_arrw_up_blk.png" border="0" alt="Sort up"/>
            </c:when>
            <c:when test="${attrName == sortingAttrNames[0] && sortingAttrOrders[0]}">
              <img style="float:left;" src="/assets/images/results_arrw_up_gr.png"  alt="Sort up" 
                  title="Result is sorted by ${sumAttrib}" />
            </c:when>
            <c:otherwise>
              <%-- display sorting buttons --%>
              <a style="float:left;" href="javascript:GetResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=asc', true)"
                  title="Sort by ${sumAttrib}">
                  <img src="/assets/images/results_arrw_up.png" alt="Sort up" border="0" /></a>
            </c:otherwise>
          </c:choose>
	  <c:choose>
            <c:when test="${!sumAttrib.sortable}">
	      <img style="float:left;" src="/assets/images/results_arrw_dwn_blk.png" border="0" />
	    </c:when>
            <c:when test="${attrName == sortingAttrNames[0] && !sortingAttrOrders[0]}">
              <img style="float:left;" src="/assets/images/results_arrw_dwn_gr.png" alt="Sort down" 
	                    title="Result is sorted by ${sumAttrib}" />
            </c:when>
            <c:otherwise>
              <%-- display sorting buttons --%>
              <a style="float:left;" href="javascript:GetResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=desc', true)"
	                    title="Sort by ${sumAttrib}">
              <img src="/assets/images/results_arrw_dwn.png" alt="Sort down" border="0" /></a>
            </c:otherwise>
          </c:choose>
             </td>
        <td nowrap>${sumAttrib.displayName}</td>
        <%-- <c:if test="${j != 0}">
          <div style="float:left;">
            <a href="javascript:void(0)">
              <img src="/assets/images/results_grip.png" alt="" border="0" /></a>
          </div>
        </c:if> --%>
        <c:if test="${j != 0}">
          <td>
            <%-- display remove attribute button --%>
            <a href="javascript:GetResultsPage('${commandUrl}&command=remove&attribute=${attrName}', true)"
                        title="Remove ${sumAttrib} column">
              <img src="/assets/images/results_x.png" alt="Remove" border="0" /></a>
          </td>
        </c:if>
      <%-- </div> --%>
         </tr>
      </table>
    </th>
  <c:set var="j" value="${j+1}"/>
  </c:forEach>
</tr>
</thead>


<tbody>

<!--
<c:if test = "${cryptoIsolatesQuestion}">
   <tr><td colspan="10" align="center"> 
       
       <c:if test = "${cryptoIsolatesQuestion}">
          <table width="100%" border="0" cellpadding="3" cellspacing="0">
         <tr align=center>
         <th>  Please select at least two isolates to run ClustalW
              <input type="button" value="Run Clustalw" onClick="goToIsolate()" />
         </th>
	 </tr>
         </table>
       </c:if>
   </td></tr>

</c:if>
-->

<c:set var="i" value="0"/>

<c:forEach items="${wdkAnswer.records}" var="record">

<c:choose>
  <c:when test="${i % 2 == 0}"><tr class="lines"></c:when>
  <c:otherwise><tr class="linesalt"></c:otherwise>
</c:choose>

  <c:set var="j" value="0"/>

  <c:forEach items="${wdkAnswer.summaryAttributeNames}" var="sumAttrName">
    <c:set value="${record.summaryAttributes[sumAttrName]}" var="recAttr"/>
    <c:set var="align" value="align='${recAttr.attributeField.align}'" />
    <c:set var="nowrap">
        <c:if test="${recAttr.attributeField.nowrap}">nowrap</c:if>
    </c:set>

    <c:set value="${record.primaryKey}" var="primaryKey"/>
    <c:set var="pkValues" value="${primaryKey.values}" />
    <c:set var="projectId" value="${pkValues['project_id']}" />
    <c:set var="id" value="${pkValues['source_id']}" />

    <td ${align} ${nowrap}>
      <c:set var="recNam" value="${record.recordClass.fullName}"/>
      <c:set var="fieldVal" value="${recAttr.briefValue}"/>
      <c:choose>
        <c:when test="${j == 0}">

        <c:choose>
           <c:when test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
               
              <a href="javascript:create_Portal_Record_Url('${recNam}', '${projectId}', '${id}','')">
                   ${primaryKey.value}</a>
           </c:when>

           <c:when test = "${cryptoIsolatesQuestion}">

              <%-- display a link to record page --%>
              <nobr><a href="showRecord.do?name=${recNam}&project_id=${projectId}&primary_key=${id}">${fieldVal}</a><input type="checkbox" name="selectedFields" value="${primaryKey.value}"></nobr>

           </c:when>

            <c:otherwise>


              <%-- display a link to record page --%>
              <a href="showRecord.do?name=${recNam}&project_id=${projectId}&primary_key=${id}">${fieldVal}</a>
              <%--   <span id="gene_id_${fieldVal}"> <a href="javascript:ToggleGenePageView('gene_id_${fieldVal}', 'showRecord.do?name=${recNam}&project_id=${projectId}&primary_key=${id}')">${fieldVal}</a></span> --%>



            </c:otherwise>
        </c:choose>

        </c:when>   <%-- when j=0 --%>

        <c:otherwise>

          <!-- need to know if fieldVal should be hot linked -->
          <c:choose>
			<c:when test="${fieldVal == null || fn:length(fieldVal) == 0}">
               <span style="color:gray;">N/A</span>
            </c:when>
            <c:when test="${recAttr.class.name eq 'org.gusdb.wdk.model.LinkAttributeValue'}">
               <c:choose>
		  <c:when test="${fn:containsIgnoreCase(dispModelName, 'ApiDB')}">
		    <a href="javascript:create_Portal_Record_Url('','${projectId}','','${recAttr.url}')">
                      ${recAttr.displayText}</a>
	          </c:when>
	          <c:otherwise>
		    <a href="${recAttr.url}">${recAttr.displayText}</a>
		  </c:otherwise>
	       </c:choose>
            </c:when>
            <c:otherwise>
              ${fieldVal}
            </c:otherwise>
          </c:choose>

        </c:otherwise>
      </c:choose>
    </td>
    <c:set var="j" value="${j+1}"/>

  </c:forEach>
</tr>
<c:set var="i" value="${i+1}"/>
</c:forEach>

</tr>

</tbody>
</table>

<c:if test = "${cryptoIsolatesQuestion}">
  </form>
</c:if>

<c:if test = "${cryptoIsolatesQuestion}">
<table width="100%" border="0" cellpadding="3" cellspacing="0">
  <tr align=center>
    <th> <br/> 
          Please select at least two isolates to run ClustalW <br/> 
      <input type="button" value="Run Clustalw on Checked Strains" onClick="goToIsolate()" />
    </th>
	</tr>
</table>
</c:if>

</div> <!-- END OF RESULTS PANE -->

<br>

  <!-- pager at bottom -->
  <wdk:pager pager_id="bottom"/>
</pg:pager>

  </c:otherwise>
</c:choose>


  </td>
  <td valign=top class=dottedLeftBorder></td> 
</tr>
</table>
