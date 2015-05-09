<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="random" uri="http://jakarta.apache.org/taglibs/random-1.0" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="from"
              description="jsp that calls this tag"
%>


<%-- get wdkModel saved in application scope --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="modelName" value="${wdkModel.displayName}"/>
<c:set var="version" value="${wdkModel.version}"/>
<c:set var="qSetMap" value="${wdkModel.questionSetsMap}"/>

<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />

<%--------------------------------------------------------------------%>

<script type="text/javascript">
  $(function() { wdk.tooltips.assignTooltipsLeftJustified('.queryGridLink'); });
</script>

<%-- these divs are needed because they do NOT come from header.... problem associated with having a sidebar --%>

<c:if test="${from != 'tab'}">
<div id="contentwrapper">
  <div id="contentcolumn">
	<div class="innertube">
</c:if>


<%-- QUERIES --%>
<%-- the cellspacing is what allows for separation between Genomic and SNP (EST and ORF) titles --%>
<%-- with new UI design the cellspacing/cellpdding of the table seems useless, innertube2 class provdes the padding --%>

<div style="padding-top:5px;" class="h3center">
	Select a search, which will be the first step in you new strategy.
</div>


<table id="queryGrid" width="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td colspan="3">  
    <div class="smallBlack" align="center">
	(Click on &nbsp; 
	<imp:image src="images/eupathdb_letter.gif" border='0' alt='eupathdb'/> &nbsp; to access a search in <b><a href="http://eupathdb.org">EuPathDB.org</a></b>)
	</div>
</td></tr>


<%-----------------------------------------------------------------------------%>
<%--  All Gene Queries  --%>
<tr class="headerrow2"><td colspan="4" align="center"><b>Identify Genes by:</b></td></tr>

<tr><td colspan="3" align="center">
	<imp:queryGridGenes/>
</td></tr>

<%-----------------------------------------------------------------------------%>

<tr>

 <%--  All SNP Queries TABLE --%>
    <td >    
<div class="innertube2"> 
	<table width="100%" border="0" cellspacing="10" cellpadding="10"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify SNPs by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridSNPs/>
		</td></tr>
   	</table> 
</div>
    </td>

<%--  All SNP CHIP Queries TABLE --%>
    <td >    
<div class="innertube2"> 
	<table width="100%" border="0" cellspacing="10" cellpadding="10"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify SNPs (from Chips) by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridSNPChips/>
		</td></tr>
   	</table> 
</div>
    </td>


</tr>

<%-----------------------------------------------------------------------------%>
<%--  All Pathways and Compounds  --%>
<tr>
    <%-- All Pathways Queries TABLE  --%>
    <td >     
<div class="innertube2">
	<table width="100%" border="0" cellspacing="10" cellpadding="10"> 
		<tr class="headerrow2">
			<td style="padding-top:0"  align="center"><b>Identify Pathways by:</b>

<imp:image alt="Beta feature icon" title="This search is new and under revision, please provide feedback using the Contact Us link on the top
 header." src="wdk/images/beta2-40.png" />

</td>
		</tr>
		<tr><td align="center">
			<imp:queryGridPathways/>
		</td></tr>	
	</table> 
</div>
    </td>

    <%--  All Compounds Queries TABLE --%>
    <td > 
<div class="innertube2">     
	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
		<tr class="headerrow2">
			<td  style="padding-top:0"  align="center"><b>Identify Compounds by:

<imp:image alt="Beta feature icon" title="This search is new and under revision, please provide feedback using the Contact Us link on the top
 header." src="wdk/images/beta2-40.png" />

</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridCompounds/>
		</td></tr>
   	</table> 
</div>
    </td>
</tr>

<%-----------------------------------------------------------------------------%>
<%--  All Genomic and Segments  --%>
<tr>
    <%-- All Genomic Sequences (CONTIG) Queries TABLE  --%>
    <td >     
<div class="innertube2">
	<table width="100%" border="0" cellspacing="10" cellpadding="10"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify Genomic Sequences by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridContigs/>
		</td></tr>	
	</table> 
</div>
    </td>

    <%--  All Genomic Segments Queries TABLE --%>
    <td > 
<div class="innertube2">     
	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify Genomic Segments by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridSegms/>
		</td></tr>
   	</table> 
</div>
    </td>
</tr>

<%-----------------------------------------------------------------------------%>
<%--  All EST and ISOLATES --%>
<tr>
    <%-- All EST Queries TABLE  --%>
    <td >     
<div class="innertube2"> 
	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify ESTs by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridESTs/>
		</td></tr>	
	</table> 
</div>
    </td>

   <%--  Isolates  --%>

 <td >     
<div class="innertube2"> 
	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 

  <tr class="headerrow2"><td colspan="2" align="center"><b>Identify Isolates by:</b></td></tr>
  <tr><td colspan="3" align="center">
	<imp:queryGridIsolates/> 
  </td></tr>

	</table> 
</div>
    </td>

</tr>


<%-----------------------------------------------------------------------------%>
<%--  All ORF Queries TABLE --%>
<tr>

    <td >   
<div class="innertube2">   
	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
		<tr class="headerrow2">
			<td   align="center"><b>Identify ORFs by:</b></td>
		</tr>
		<tr><td align="center">
			<imp:queryGridORFs/>
		</td></tr>
   	</table> 
</div>
    </td>
</tr>


</table>

<%-- these divs need to be closed because they do NOT come from header.... problem associated with having a sidebar --%>

<c:if test="${from != 'tab'}">
    </div>
  </div>
</div>
</c:if>
