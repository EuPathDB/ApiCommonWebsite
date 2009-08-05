<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>

<%@ attribute name="model"
             type="org.gusdb.wdk.model.jspwrap.WdkModelBean"
             required="false"
             description="Wdk Model Object for this site"
%>

<%@ attribute name="user"
              type="org.gusdb.wdk.model.jspwrap.UserBean"
              required="false"
              description="Currently active user object"
%>

<c:set var="unsavedStrategiesMap" value="${user.unsavedStrategiesByCategory}"/>
<c:set var="savedStrategiesMap" value="${user.savedStrategiesByCategory}"/>
<c:set var="invalidStrategies" value="${user.invalidStrategies}"/>
<c:set var="modelName" value="${model.name}"/>
<c:set var="showOrthoLink" value="${fn:containsIgnoreCase(modelName, 'plasmodb') || fn:containsIgnoreCase(modelName, 'apidb') || fn:containsIgnoreCase(modelName, 'cryptodb')}" />

<!-- decide whether strategy history is empty -->
<c:choose>
  <c:when test="${user == null || user.strategyCount == 0}">
  <div style="font-size:120%;line-height:1.2em;text-indent:10em;padding:0.5em">You have no search strategies in your history. <p style="text-indent:5em;">Please run a search to start a strategy: from the <a href="/">home</a> page, or by using the "New Search" menu above, or by clicking on the "New Strategy" tab above.</p></div>
  </c:when>
  <c:otherwise>
  <c:set var="typeC" value="0"/>
  <!-- begin creating tabs for history sections -->
  <ul id="history_tabs">
  <c:forEach items="${unsavedStrategiesMap}" var="strategyEntry">
    <c:set var="type" value="${strategyEntry.key}"/>
    <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
    <c:set var="unsavedStratList" value="${strategyEntry.value}"/>
    <c:set var="savedStratList" value="${savedStrategiesMap[type]}" />

    <c:if test="${fn:length(unsavedStratList) > 0 || fn:length(savedStratList) > 0}">
      <c:choose>
        <c:when test="${fn:length(unsavedStratList) > 0}">
          <c:set var="strat" value="${unsavedStratList[0]}" />
        </c:when>
        <c:otherwise>
          <c:set var="strat" value="${savedStratList[0]}" />
        </c:otherwise>
      </c:choose>
      <c:set var="recDispName" value="${strat.displayType}"/>
      <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' '))}"/>

      <c:set var="typeC" value="${typeC+1}"/>
      <c:if test="${typeC != 1}">
        <li>|</li>
      </c:if>
      <li>
        <a id="tab_${recTabName}" onclick="displayHist('${recTabName}')"
           href="javascript:void(0)">${recDispName}&nbsp;Strategies</a>
      </li>
    </c:if>
  </c:forEach>

  <c:if test="${fn:length(invalidStrategies) > 0}">
    <li>
      <a id="tab_invalid" onclick="displayHist('invalid')"
       href="javascript:void(0)">Invalid&nbsp;Strategies</a></li>
  </c:if>
  <li class="cmplt_hist_link">
    <a id="tab_cmplt" onclick="displayHist('cmplt')" href="javascript:void(0)">All My Queries</a>
  </li>
  </ul>


<%-- display link to old site if user is logged in (temp) --%>
<c:if test="${!wdkUser.guest}">
<c:set var="projectId" value="${model.projectId}" />
<c:set var="previousSite">
  <c:choose>
    <c:when test="${projectId == 'CryptoDB'}">http://old.cryptodb.org</c:when>
    <c:when test="${projectId == 'EuPathDB'}">http://old.eupathdb.org</c:when>
    <c:when test="${projectId == 'GiardiaDB'}">http://old.giardiadb.org</c:when>
    <c:when test="${projectId == 'PlasmoDB'}">http://old.plasmodb.org</c:when>
    <c:when test="${projectId == 'ToxoDB'}">http://old.toxodb.org</c:when>
    <c:when test="${projectId == 'TrichDB'}">http://old.trichdb.org</c:when>
    <c:when test="${projectId == 'TriTrypDB'}">http://old.tritrypdb.org</c:when>
  </c:choose>
</c:set>

<site:qhWarning prevSite="${previousSite}" />
</c:if>  <%-- end display link to old site --%>


<table class="history_controls clear_all">
   <tr>
      <td>Select:&nbsp;<a class="check_toggle" onclick="selectAllHist()" href="javascript:void(0)">All</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectAllHist('saved')" href="javascript:void(0)">Saved</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectAllHist('unsaved')" href="javascript:void(0)">Unsaved</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectNoneHist()" href="javascript:void(0)">None</a></td>
      <td class="medium">
         <input type="button" value="Open" onclick="handleBulkStrategies('open')"/>
         <input type="button" value="Close" onclick="handleBulkStrategies('close')"/>
         <input type="button" value="Delete" onclick="handleBulkStrategies('delete')"/>
      </td>
   </tr>
</table>

<!-- begin creating history sections to display strategies -->
<c:forEach items="${unsavedStrategiesMap}" var="strategyEntry">
  <c:set var="type" value="${strategyEntry.key}"/>
  <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:set var="recDispName" value="${strategies[0].displayType}"/>
  <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' '))}"/>

  <c:if test="${fn:length(strategies) > 0}">
    <div class="panel_${recTabName} history_panel unsaved-strategies">
      <site:strategyTable strategies="${strategies}" wdkUser="${wdkUser}" prefix="Unsaved" />
    </div>
  </c:if>
</c:forEach>
<!-- end of showing strategies grouped by RecordTypes -->
<br/>
<!-- begin creating history sections to display strategies -->
<c:forEach items="${savedStrategiesMap}" var="strategyEntry">
  <c:set var="type" value="${strategyEntry.key}"/>
  <c:set var="isGeneRec" value="${fn:containsIgnoreCase(type, 'GeneRecordClass')}"/>
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:set var="recDispName" value="${strategies[0].displayType}"/>
  <c:set var="recTabName" value="${fn:substring(recDispName, 0, fn:indexOf(recDispName, ' '))}"/>

  <c:if test="${fn:length(strategies) > 0}">
    <div class="panel_${recTabName} history_panel saved-strategies">
      <site:strategyTable strategies="${strategies}" wdkUser="${wdkUser}" prefix="Saved" />
    </div>
  </c:if>
</c:forEach>
<!-- end of showing strategies grouped by RecordTypes -->

<c:set var="scheme" value="${pageContext.request.scheme}" />
<c:set var="serverName" value="${pageContext.request.serverName}" />
<c:set var="request_uri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<c:set var="request_uri" value="${fn:substringAfter(request_uri, '/')}" />
<c:set var="request_uri" value="${fn:substringBefore(request_uri, '/')}" />
<c:set var="exportBaseUrl" value = "${scheme}://${serverName}/${request_uri}/im.do?s=" />

<!-- popups for save/rename forms -->
<%--<c:set var="unsavedStrategiesMap" value="${user.unsavedStrategiesByCategory}"/>
<c:forEach items="${unsavedStrategiesMap}" var="strategyEntry">
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:forEach items="${strategies}" var="strategy">
    <c:set var="saveHeader" value="Unused"/>--%>
    <div class='modal_div save_strat' id="hist_save_rename">
      <div class='dragHandle' style='height:4px'>
        <div class="modal_name">
          <span id='popup-title' class='h3left'></span>
        </div>
        <a class='close_window' href='javascript:closeModal()'>
        <img alt='Close' src='/assets/images/Close-X.png'  height='16'/>
        </a>
      </div>
      <form id='save_strat_form' onsubmit='return validateSaveForm(this);'><!-- action="javascript:saveStrategy('${strategy.strategyId}', true, true)">-->
        <input type='hidden' value="" name='strategy'/>
        <input type='text' value="" name='name' maxlength='200'/>
        <input  style='margin-left:5px;' type='submit' value='Save'/>
      </form>
    </div>
<%--  </c:forEach>
</c:forEach>

<c:if test="${!wdkUser.guest}">
<c:set var="savedStrategiesMap" value="${user.savedStrategiesByCategory}"/>
<c:forEach items="${savedStrategiesMap}" var="strategyEntry">
  <c:set var="strategies" value="${strategyEntry.value}"/>
  <c:forEach items="${strategies}" var="strategy">
    <c:set var="exportURL" value="${exportBaseUrl}${strategy.importId}" />
    <div class='modal_div export_link' id="hist_share_${strategy.strategyId}" >
      <div class='dragHandle'  style='height:4px'>
	 <div class="modal_name">
		<span class="h3left">Copy and paste URL below to email or bookmark</span>
	 </div>
         <a class='close_window' href='javascript:closeModal()'>
         <img alt='Close' src='/assets/images/Close-X.png'  height='16'/>
         </a>
      </div>
      <input type='text' size="${fn:length(exportURL)-12}" value="${exportURL}"/>
    </div>
    <c:set var="saveHeader" value="Save As"/>
    <div class='modal_div save_strat' id="hist_save_${strategy.strategyId}">
      <div class='dragHandle'  style='height:4px'>
        <div class="modal_name">
          <span class='h3left'>${saveHeader}</span>
        </div>
        <a class='close_window' href='javascript:closeModal()'>
          <img alt='Close' src='/assets/images/Close-X.png'  height='16'/>
        </a>
      </div>
      <form onsubmit='return validateSaveForm(this);' action="javascript:saveStrategy('${strategy.strategyId}', true, true)">
        <input type='hidden' value="${strategy.strategyId}" name='strategy'/>
        <input type='text' value="${strategy.name}" name='name'/>
        <input  style='margin-left:5px' type='submit' value='Save'/>
      </form>
    </div>
  </c:forEach>
</c:forEach>
</c:if>--%>

<%-- invalid strategies, if any --%>
<c:if test="${fn:length(invalidStrategies) > 0}">
    <div class="panel_invalid history_panel unsaved-strategies">
      <site:strategyTable strategies="${user.invalidStrategies}" wdkUser="${wdkUser}" prefix="Invalid" />
    </div>
</c:if>

<div class="panel_cmplt history_panel">
  <h1>All My Queries</h1>
  <div class="loading"></div>
</div>

<table class="history_controls">
   <tr>
      <td>Select:&nbsp;<a class="check_toggle" onclick="selectAllHist()" href="javascript:void(0)">All</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectAllHist('saved')" href="javascript:void(0)">Saved</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectAllHist('unsaved')" href="javascript:void(0)">Unsaved</a>&nbsp|&nbsp;
                  <a class="check_toggle" onclick="selectNoneHist()" href="javascript:void(0)">None</a></td>
      <td class="medium">
         <input type="button" value="Open" onclick="handleBulkStrategies('open')"/>
         <input type="button" value="Close" onclick="handleBulkStrategies('close')"/>
         <input type="button" value="Delete" onclick="handleBulkStrategies('delete')"/>
      </td>
   </tr>
</table>

  </c:otherwise>
</c:choose> 
<!-- end of deciding strategy emptiness -->


<c:if test="${!wdkUser.guest}">
	<hr>
	<site:qhWarning prevSite="${previousSite}"/>
</c:if> <%-- end of test & display urls to old site --%>

