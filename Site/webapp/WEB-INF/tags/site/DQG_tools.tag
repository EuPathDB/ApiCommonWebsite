<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="modelName" value="${applicationScope.wdkModel.name}" />
<c:set var="sName" value="${fn:substringBefore(modelName,'DB')}" />
<c:set var="cycName" value="${sName}Cyc" />

<c:choose>
        <c:when test="${fn:containsIgnoreCase(modelName, 'EuPathDB')}">
		<c:set var="listOrganisms" value="Eukaryotic Pathogens"/>
	</c:when>
        <c:when test="${fn:containsIgnoreCase(modelName, 'CryptoDB')}">
		<c:set var="listOrganisms" value="Cryptosporidium"/>
	</c:when>
        <c:when test="${fn:containsIgnoreCase(modelName, 'ToxoDB')}">
                <c:set var="listOrganisms" value="Eimeria, Gregarina, Neospora, Toxoplasma"/>
        </c:when>
	<c:when test="${fn:containsIgnoreCase(modelName, 'PlasmoDB')}">
		<c:set var="listOrganisms" value="Plasmodium"/>
	</c:when>
 	<c:when test="${fn:containsIgnoreCase(modelName, 'GiardiaDB')}">
		<c:set var="listOrganisms" value="Giardia"/>
	</c:when>
 	<c:when test="${fn:containsIgnoreCase(modelName, 'TrichDB')}">
		<c:set var="listOrganisms" value="Trichomonas"/>
	</c:when>
 	<c:when test="${fn:containsIgnoreCase(modelName, 'TriTrypDB')}">
		<c:set var="listOrganisms" value="Crithidia, Endotrypanum, Leishmania, Trypanosoma"/>
	</c:when>
</c:choose> 

<div class="info">
    	<ul> 
		<li><a href="<c:url value="/showQuestion.do?questionFullName=UniversalQuestions.UnifiedBlast"/>"><strong>BLAST</strong></a>
			<ul><li style="border:0">Identify Sequence Similarities</li></ul>
		</li>
		<li><a href="<c:url value="/srt.jsp"/>"><strong>Sequence Retrieval</strong></a>
			<ul><li  style="border:0">Retrieve Specific Sequences using IDs and coordinates</li></ul>
		</li>
	<li><a href="http://pathogenportal.org"><strong>Pathogen Portal</strong></a>
			<ul><li  style="border:0">RNA sequence analysis, interactome maps and more</li></ul>
		</li>
		<li><a href="/pubcrawler/${modelName}"><strong>PubMed and Entrez</strong></a>
			<ul><li  style="border:0">View the Latest Pubmed and Entrez Results</li></ul>
		</li>

<c:if test="${sName != 'EuPath'}">
		<li><a href="/cgi-bin/gbrowse/${fn:toLowerCase(modelName)}/"><strong>Genome Browser</strong></a>
			<ul><li  style="border:0">View Sequences and Features in the genome browser</li></ul>
		</li>
</c:if>

		<li><a href="/plasmo.dfalke/analysisTools.jsp"><strong>Results Analyzer</strong></a>
			<ul><li  style="border:0">Analyze Your Strategy Results</li></ul>
		</li>
    


<c:choose>   <%-- SITES WITH FEW TOOLS, SO THERE IS SPACE IN BUCKET FOR DESCRIPTIONS --%>
<c:when test="${sName != 'Plasmo'}">

	<c:choose>
	<c:when test="${sName == 'Crypto'}">

                <li><a href="http://apicyc.apidb.org/CPARVUM/server.html"><strong>${cycName}</strong></a>
                        <ul><li  style="border:0">Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>

		<li><a href="<c:url value="/serviceList.jsp"/>"><strong>Searches via Web Services</strong></a>
			<ul><li style="border:0">Learn about web service access to our data</li></ul>
		</li>
	</c:when>
	<c:when test="${sName == 'EuPath'}">
                <li><a href="http://apicyc.apidb.org/"><strong>ApiCyc</strong></a>
                        <ul><li  style="border:0">Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>

		<li><a href="<c:url value="/serviceList.jsp"/>"><strong>Searches via Web Services</strong></a>
			<ul><li style="border:0">Learn about web service access to our data</li></ul>
		</li>
	</c:when>
	<c:when test="${sName == 'Toxo'}">
		<li><a href="http://ancillary.toxodb.org"><strong>Ancillary Genome Browse</strong></a>
                        <ul><li  style="border:0">Access Probeset data and <i>Toxoplasma</i> Array info</li></ul>
                </li>

		<li><p>
			<i>For additional tools, use the </i><b>Tools</b><i> menu in the gray toolbar above.....</i></p>
		</li>

<%--          
                <li><a href="http://apicyc.apidb.org/${sName}/server.html"><strong>${cycName}</strong></a>
                        <ul><li  style="border:0">Explore Automatically Defined Metabolic Pathways</li></ul>
                </li>
--%>
	</c:when>
	<c:otherwise>   <%----- Giardia, Trich and TriTryp:  fill in 2 empty lines to keep buckets aligned -----%>

		<li><a href="<c:url value="/serviceList.jsp"/>"><strong>Searches via Web Services</strong></a>
			<ul><li style="border:0">Learn about web service access to our data</li></ul>
		</li>
                <%-- <li>&nbsp;<ul><li  style="border:0">&nbsp;</li></ul></li> --%>

	</c:otherwise>
	</c:choose>

    	</ul>
</c:when>
<c:otherwise>   <%-- PLASMO: LOTS OF TOOLS, add descriptions as mouseovers --%>

  		<li><p><i>For additional tools, use the </i><b>Tools</b><i> menu in the gray toolbar above.....</i></p>
		</li>

	</ul>

</c:otherwise>
</c:choose>

</div>

<div class="infobottom tools">
</div><!--end info-->
