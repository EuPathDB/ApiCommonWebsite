

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>

<%@ attribute name="strategy"
	      type="org.gusdb.wdk.model.jspwrap.StrategyBean"
              required="true"
              description="Protocol from the SummaryPage"
%>
<%@ attribute name="strat_step"
	      type="org.gusdb.wdk.model.jspwrap.StepBean"
              required="true"
              description="Protocol from the SummaryPage"
%>
<c:set var="sub"value="false" />
<c:set var="stratName" value="${strategy.name}" />
<c:set var="stratId" value="${strategy.strategyId}" />
<c:if test="${strat_step.stepId != strategy.latestStep.stepId}">
	<c:set var="sub" value="true" />
	<c:set var="stratName" value="${strat_step.collapsedName}" />
	<c:set var="stratId" value="${strategy.strategyId}_${strat_step.stepId}" />
</c:if>

<!--<link rel="stylesheet" type="text/css" href="/assets/css/Strategy.css" />
<link rel="StyleSheet" href="/assets/css/filter_menu.css" type="text/css"/>-->
<c:set var="stepNumber" value="0" />
<!--<div class="chain_background" id="bread_crumb_div">-->
	<div class="diagram" id="diagram_${stratId}">
		<span class="closeStrategy"><a href="javascript:void(0)" onclick="closeStrategy(${stratId})"><img src="/assets/images/Close-X.png" alt="click here to remove ${stratName} from the list"/></a></span>
		<div id="strategy_name">${stratName}<span id="strategy_id_span" style="display:none">${stratId}</span><span class="strategy_small_text"><br>save as<br>export</span></div>
		<c:set var="steps" value="${strat_step.allSteps}" />
		<c:forEach items="${steps}" var="step">
			<site:Step step="${step}" strategy="${strategy}" stepNum="${stepNumber}"/>
			<c:set var="stepNumber" value="${stepNumber+1}" />
		</c:forEach>
		<a class="filter_link redbutton" onclick="this.blur()" href="javascript:openFilter('${stratId}:')" id="filter_link"><span>Add Step</span></a>
	</div>
	<div class="filter_link_div" id="filter_link_div_${stratId}">
		<site:FilterInterface model="${applicationScope.wdkModel}" recordClass="${strat_step.dataType}" strategy="${strategy}"/>
	</div>
<!--</div>-->




