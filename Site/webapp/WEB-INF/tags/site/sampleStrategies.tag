<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="random" uri="http://jakarta.apache.org/taglibs/random-1.0" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>
<%@ taglib prefix="nested" uri="http://jakarta.apache.org/struts/tags-nested" %>

<%@ attribute name="wdkModel"
             type="org.gusdb.wdk.model.jspwrap.WdkModelBean"
             required="false"
             description="Wdk Model Object for this site"
%>

<%@ attribute name="wdkUser"
    type="org.gusdb.wdk.model.jspwrap.UserBean"
    required="true"
    description="Currently active user object"
%>

<c:set var="wdkUser" value="${sessionScope.wdkUser}"/>
<c:set var="version" value="${wdkModel.version}"/>
<c:set var="site" value="${wdkModel.displayName}"/>

<%--  <h1>Sample Strategies</h1>  --%>
<br><br>

<%-------------  Set sample strategy signatures in all sites  ----------------%>
<c:choose>
   <c:when test="${fn:containsIgnoreCase(site, 'CryptoDB')}">
      <c:set var="simple" value="ca5bc32fb29086d29b778b17f18a97c:11" />
      <c:set var="expanded" value="ca5bc32fb29086d29b778b17f18a97c:12" />
   </c:when>

<c:when test="${fn:containsIgnoreCase(site, 'GiardiaDB')}">
      <c:set var="simple" value="ca5bc32fb29086d29b778b17f18a97c:5" />
      <c:set var="expanded" value="ca5bc32fb29086d29b778b17f18a97c:3" />
   </c:when>

 <c:when test="${fn:containsIgnoreCase(site, 'PlasmoDB')}">
      <c:set var="simple" value="ca5bc32fb29086d29b778b17f18a97c:7" />
      <c:set var="expanded" value="ca5bc32fb29086d29b778b17f18a97c:8" />
      <c:set var="expressed" value="ca5bc32fb29086d29b778b17f18a97c:13" />
      <c:set var="expressedPknowlesi" value="ca5bc32fb29086d29b778b17f18a97c:14" />
      <c:set var="PfalVaccineAg" value="b57717e3cb5c116dc7daabe8ef4ef4de:13" />
      <c:set var="PfalDrugTargets" value="ca5bc32fb29086d29b778b17f18a97c:15" />
      <c:set var="vivaxCryptoOrthologs" value="9de59ccd16cadc9c43bdd36a625fbbdd:17" />
   </c:when>

<c:when test="${fn:containsIgnoreCase(site, 'ToxoDB')}">
      <c:set var="simple" value="ca5bc32fb29086d29b778b17f18a97c:1" />
      <c:set var="expanded" value="ca5bc32fb29086d29b778b17f18a97c:6" />

   </c:when>

<c:when test="${fn:containsIgnoreCase(site, 'TrichDB')}">

   </c:when>

 <c:when test="${fn:containsIgnoreCase(site, 'TriTrypDB')}">
      <c:set var="simple" value="ca5bc32fb29086d29b778b17f18a97c:1" />
      <c:set var="expanded" value="ca5bc32fb29086d29b778b17f18a97c:2" />
      <c:set var="expressed" value="ca5bc32fb29086d29b778b17f18a97c:3" />
      <c:set var="expressedLbrazilliensis" value="ca5bc32fb29086d29b778b17f18a97c:5" />
   </c:when>


<c:when test="${fn:containsIgnoreCase(site, 'ApiDB')}">
 
   </c:when>

</c:choose>

<div class="h2center">Click to import a strategy in your workspace</div>

<table class="tableWithBorders" style="margin-left: auto; margin-right: auto;" width="90%">

<tr align = "center" style="font-weight:bold"><td>Strategy name</td><td>Example of</td><td>Description</td></tr>

<c:if test="${simple != null}">
<tr align = "left">
	<td><a title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${simple}"/>">Prot Cod Sig Pep EST Evidence</a> </td>
	<td>Simple strategy</td>
	<td>Find all protein coding genes that have a signal peptide and evidence for expression based on EST alignments</td>
</tr>
</c:if>

<c:if test="${expanded != null}">
  <tr align = "left">
	<td><a  title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${expanded}"/>">kin, TM, (EST or Prot) ortho</a> </td>
	<td>Strategy with nested strategy and transform</td>
	<td>Find all kinases that have at least one transmembrane domain and evidence for expression based on EST alignments or proteomics evidence and transform the result to identify all orthologs since not all organisms have expression evidence</td>
</tr>
</c:if>

<c:if test="${expressed != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${expressed}"/>">Expressed Genes</a> </td>
	<td>Strategy with a nested strategy</td>
	<td>Find all genes in the database that have any direct evidence for expression</td>
</tr>
</c:if>

<c:if test="${expressedLbrazilliensis != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${expressedLbrazilliensis}"/>"><i>L. brazilliensis</i> Expressed Genes</a> </td>
	<td>Strategy with an ortholog transform</td>
	<td>Find all genes from <i>L. brazilliensis</i> that have any evidence for expression based on direct evidence or using orthology</td>
</tr>
</c:if>

<c:if test="${expressedPknowlesi != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${expressedPknowlesi}"/>">P.knowlesi Expressed Genes</a> </td>
	<td>Strategy with a nested strategy and an ortholog transform</td>
	<td>Find all genes from <i>P. knowlesi</i> that have any evidence for expression based on orthology to other <i>Plasmodium</i> species</td>
</tr>
</c:if>

<c:if test="${PfalVaccineAg != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${PfalVaccineAg}"/>"><i>P.falciparum</i> candidate vaccine antigens</a> </td>
	<td>Simple stategy to identify potential vaccine antigens</td>
	<td>Find all genes from <i>P. falciparum</i> that that could be worth following up as a potential vaccine antigen.  Note that there are many ways to do this search ... experiment with different parameter settings and incorporating different queries.</td>
</tr>
</c:if>

<c:if test="${PfalDrugTargets != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${PfalDrugTargets}"/>"><i>P.falciparum</i> candidate drug targets</a> </td>
	<td>Nested stategy to identify potential drug targets.</td>
	<td>Find genes from <i>P. falciparum</i> that that could be worth following up as potential drug targets.  Note that there are many ways to do this search ... experiment with different parameter settings and incorporating different queries.</td>
</tr>
</c:if>

<c:if test="${vivaxCryptoOrthologs != null}">
<tr align = "left">
	<td><a   title="Click to import this strategy in your workspace" href="<c:url value="/importStrategy.do?strategy=${vivaxCryptoOrthologs}"/>"><i>P.vivax</i> orthologs</a> </td>
	<td>Simple stategy</td>
	<td><i>P. vivax</i> orthologs of cryptosporidium genes that have evidence of expression in oocysts.</td>
</tr>
</c:if>

</table>

<br><br>

<%--   <h1>Help</h1>  --%>
<div class="h2center">For detailed information on the use of strategies see the <a href="http://eupathdb.org/tutorials/New_Strat/New_Strat_viewlet_swf.html">Tutorial</a> (5 minutes)</div><br>
The following image shows some of the functionality of the Run Strategies tab.  Mousing over these (and other) elements when you are running strategies will provide context sensitive help. Of particular note, clicking the title for any step shows the details for that step and provides a menu that allows you to modify the step by editing search parameters, deleting or inserting a step, etc.  Clicking the number of records for any step allows you to see and filter the results for that particular step.<br>
<center>
<img src="/images/strategy_help.jpg">
</center>

