
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="wdkQuestion" value="${requestScope.wdkQuestion}"/>
<c:set var="recordType" value="${wdkQuestion.recordClass.type}"/>
<c:set var="projectId" value="${applicationScope.wdkModel.projectId}" />

<%-- QUESTIONS --%>
<%-- 	study is a keyword --if the questionset name contains "study" we will revise this....
	when the keyword "study" is found, queryList.tag will make a new row
	a study belongs to an organism and contains questions, 
	questions will be displayed in columns --number of columns is determined below
	several studies can belong to the same organism 
	queryList.tag contains the organism mapping (from E.hi to Entamoeba histolytica, etc)
	if this becomes difficult to maintain, we would show acronyms.
--%>
<c:set var="fungiQuestions" value="Calbstudy:C.albicans antifungal activity,GeneQuestions.GenesByMicroarrayPercentileCalbAntiFung,Scerstudy:S.cerevisiae Time Series,GeneQuestions.GenesByMicroarrayTimeSeriesSc" />

<c:set var="amoebaQuestions" value="E.hi.study:Colonization-Invasion and Stage Conversion (Gilchrist),GeneQuestions.GenesByEHistolyticaExpressionTiming,GeneQuestions.GenesByExpressionTimingPercentileGilchrist,E.hi.study:G3 v. HM1:IMSS Transcript Expression (Gilchrist),GeneQuestions.GenesByAmoebaFoldChangeGilchrist,GeneQuestions.GenesByExpressionPercentileGilchrist,GeneQuestions.GenesByAmoebaFoldChangePageGilchrist" />

<c:set var="giardiaQuestions" value="G.l.study:Stress Response (Hehl),GeneQuestions.GiardiaGenesByDifferentialExpression,GeneQuestions.GiardiaGenesByExpressionPercentileProfile,G.l.study:Encystation (Hehl),GeneQuestions.GiardiaGenesByDifferentialExpressionTwo,GeneQuestions.GiardiaGenesByExpressionPercentileProfileTwo,GeneQuestions.GiardiaGenesFoldChangeTwo,G.l.study:Host Parasite Interaction (Svard),GeneQuestions.GenesByRingqvistFoldChange,GeneQuestions.GenesByRingqvistPercentile,G.l.study:Cell Cycle (Troell),GeneQuestions.GenesbyFoldChangeTroellCC,GeneQuestions.GenesByPercentileTroellCC" />

<c:set var="plasmoQuestions" value="P.f.study:Intraerythrocytic Infection Cycle (DeRisi),GeneQuestions.GenesByExpressionTiming,GeneQuestions.GenesByMicroarrayPercentileDerisi,GeneQuestions.GenesByProfileSimilarity,P.f.study:Profiling of the Malaria Parasite Life Cycle (Winzeler),GeneQuestions.GenesByIntraerythroExprFoldChange,GeneQuestions.GenesByIntraerythrocyticExpression,P.f.study:Sexual Development - Gametocyte (Winzeler),GeneQuestions.GenesByExtraerythroExprFoldChange,GeneQuestions.GenesByExtraerythrocyticExpression,GeneQuestions.GenesByGametocyteExprFoldChange,GeneQuestions.GenesByGametocyteExpression,P.f.study:Invasion Pathways (Cowman),GeneQuestions.GenesByDifferentialMeanExpression,GeneQuestions.GenesByExpressionPercentileA,P.f.study:Sir2 Paralogues cooperate to Regulate Virulence Genes (Cowman),GeneQuestions.GenesByCowmanSir2FoldChange,GeneQuestions.GenesByCowmanSir2Percentile,P.f.study:Chloroquine Selected Mutations in the crt gene (Su),GeneQuestions.GenesBySuCqFoldChange,GeneQuestions.GenesBySuCqPercentile,P.f.study:eQTL studies on Hb3 X Dd2 progeny (Ferdig),GeneQuestions.GenesByEQTL_Segments,GeneQuestions.GenesByEQTL_HaploGrpSimilarity,GeneQuestions.GenesByEqtlProfileSimilarity,P.f.study:Transcriptional variation of P. falciprum strains (Cortes),GeneQuestions.GenesByCortesTranscriptVariantome3D7,,GeneQuestions.GenesByCortesTranscriptVariantomePercentile3D7,GeneQuestions.GenesByCortesTranscriptVariantome7G8,GeneQuestions.GenesByCortesTranscriptVariantomePercentile7G8,GeneQuestions.GenesByCortesTranscriptVariantomeD10,GeneQuestions.GenesByCortesTranscriptVariantomePercentileD10,GeneQuestions.GenesByCortesTranscriptVariantomeHB3,GeneQuestions.GenesByCortesTranscriptVariantomePercentileHB3,GeneQuestions.GenesByCortesCGHCrossStrain,GeneQuestions.GenesByCortesCGH,P.b.study:Regulation of Sexual Development (Waters),GeneQuestions.GenesByWatersDifferentialExpression,GeneQuestions.GenesByWatersPercentile,P.b.study:Plasmodium Life Cycle Survey (Waters),GeneQuestions.BergheiGenesByExpressionFoldChange,GeneQuestions.BergheiGenesByExpressionPercentile,P.y.study:Parasite Liver Stages Survey (Kappe),GeneQuestions.GenesByKappeFoldChange,GeneQuestions.GenesByKappePercentile,P.v.study:Intraerythrocytic Infection Cycle (Carlton),GeneQuestions.GenesByVivaxExpressionTiming,GeneQuestions.GenesByPvivTimingPercentile" />

<c:set var="piroplasmaQuestions" value="B.b.study:Virulent vs Attenuated (Lau),GeneQuestions.GenesByLauBbovisFoldChange,GeneQuestions.GenesByLauBbovisPercentile,GeneQuestions.GenesByLauBbovisPaGE"/>

<c:set var="toxoQuestions" value="T.g.study:Expression profiling of Toxoplasma gondii tachyzoites (str RH/GT1/Pru/ME49/CTG/Veg) (Roos),GeneQuestions.ToxoGenesByArchetypalLinagesStrainsFC,GeneQuestions.ToxoGenesByArchetypalLinagesStrainsPct,GeneQuestions.ToxoGenesByArchetypalLinagesStrainsPage,GeneQuestions.ToxoGenesByArchetypalLinagesTypesPct,GeneQuestions.ToxoGenesByArchetypalLinagesTypesPage,T.g.study:Bradyzoite Induction Time Series (Roos/Boothroyd/White),GeneQuestions.GenesByTimeSeriesFoldChangeBradyRoos,GeneQuestions.GenesByTimeSeriesFoldChangeBradyRoosPct,GeneQuestions.GenesByTimeSeriesFoldChangeBradyFl,GeneQuestions.GenesByTimeSeriesFoldChangeBradyFlPct,GeneQuestions.GenesByTimeSeriesFoldChangeBradyBoothroyd,GeneQuestions.GenesByTimeSeriesFoldChangeBradyBoothroydPct,GeneQuestions.ToxoGenesByDifferentialMeanExpression,GeneQuestions.ToxoGenesByDifferentialMeanExpressionPct,T.g.study:Transcriptomics across the intracellular tachyzoite cell cycle (str RH / synchronized / 1-hr sampling) (White),GeneQuestions.GenesByToxoCellCycleFoldChange,GeneQuestions.GenesByToxoCellCyclePercentile,GeneQuestions.GenesByToxoProfileSimilarity,T.g.study:Expression profiling of T. gondii oocyst/tachyzoite/bradyzoite stages (str M4) (Boothroyd/Conrad),GeneQuestions.GenesByToxoFoldChangeBoothroyd,GeneQuestions.GenesByExpressionPercentileBoothroyd,T.g.study:TgGCN5 -A null mutants during bradyzoite differentiation (str RH alkali treatment) (Sullivan),GeneQuestions.GenesByToxoFoldChangeSullivan,GeneQuestions.GenesByExpressionPercentileSullivan,GeneQuestions.GenesByToxoFoldChangePageSullivan,T.g.study:Expression by Invasion Stage (Carruthers),GeneQuestions.GenesByToxoFoldChangeCarruthers,GeneQuestions.GenesByExpressionPercentileCarruthers,GeneQuestions.GenesByToxoFoldChangePageCarruthers,T.g.study:Bradyzoite Differentiation Mutant Expression (Matrajt),GeneQuestions.GenesByToxoFoldChangeMatrajt,GeneQuestions.GenesByExpressionPercentileMatrajt,GeneQuestions.GenesByToxoFoldChangePageMatrajt" />

<c:set var="tritrypQuestions" value="L.d.study:Promastigote to Amastigote Differentiation Time Series (Myler),GeneQuestions.GenesByPromastigoteTimeSeries,GeneQuestions.GenesByExpressionPercentileLinfantum,L.i.study: Axenic vs Intracellular Amastigotes Comparison (Papadopoulou),GeneQuestions.GenesByMicroArrPaGELinfantum,GeneQuestions.GenesByMicroArrPaGELinfantumPct,T.c.study:Life-Cycle Stages (Tarleton),GeneQuestions.GenesByMicroArrPaGETcruzi,GeneQuestions.GenesByExpressionPercentileTcruzi,T.b.study:Differentiation Time Series (Clayton/Matthews),GeneQuestions.GenesByTbruceiTimeSeries,GeneQuestions.GenesByExpressionPercentileTbrucei,T.b.study:RNA helicase DHH1 and post transcriptional regulation (Carrington),GeneQuestions.GenesByMicroArrPaGE_Tbrucei_DHH1,GeneQuestions.GenesByMicroArrPaGE_Tbrucei_DHH1_Pct,T.b.study:Heat shock and post transcriptional regulation (Carrington),GeneQuestions.GenesByMicroArrPaGE_Tbrucei_HeatShock,GeneQuestions.GenesByMicroArrPaGE_Tbrucei_HeatShock_Pct,T.b.study:Life-Cycle Stages (Parsons),GeneQuestions.GenesByMicroArrPaGETbrucei,GeneQuestions.GenesByExpressionPercentileBrucei5stg,T.b.study:Procyclic Trypanosomes Depleted of TbDRBD3 (Estevez),GeneQuestions.GenesByMicroArr_TbDRBD3,L.m.study:Developmental Stages (Beverley),GeneQuestions.GenesByMicroArrPaGELmajor,GeneQuestions.GenesByMicroArrPaGELmajorPct" />
<%-- END OF QUESTIONS --%>


<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set value="${wdkModel.displayName}" var="project"/>

<imp:errors/>

<%-- div needed for Add Step --%>
<div id="form_question">

<center><table width="90%">
     
<c:set value="2" var="columns"/>    <%-- affects display of questions --%>

   <tr class="headerRow">
      <td colspan="${columns + 2}" align="center">
        <b>Choose a Search</b>
        <br>
        <i style="font-size:80%">Mouse over to read description</i>
      </td>
    </tr>

<c:choose>
 <c:when test = "${project == 'FungiDB'}">
    <imp:queryList columns="${columns}" questions="${fungiQuestions}"/>
  </c:when>
 <c:when test = "${project == 'AmoebaDB'}">
    <imp:queryList columns="${columns}" questions="${amoebaQuestions}"/>
  </c:when>
  <c:when test = "${project == 'GiardiaDB'}">
    <imp:queryList columns="${columns}" questions="${giardiaQuestions}"/>
  </c:when>
  <c:when test = "${project == 'EuPathDB'}">
    <imp:queryList columns="${columns}" questions="${amoebaQuestions},${giardiaQuestions},${piroplasmaQuestions},${plasmoQuestions},${toxoQuestions},${tritrypQuestions}"/>
  </c:when>
  <c:when test = "${project == 'PiroplasmaDB'}">
    <imp:queryList  columns="${columns}"  questions="${piroplasmaQuestions}"/>
  </c:when>
  <c:when test = "${project == 'PlasmoDB'}">
    <imp:queryList  columns="${columns}"  questions="${plasmoQuestions}"/>
  </c:when>
  <c:when test = "${project == 'ToxoDB'}">
    <imp:queryList columns="${columns}" questions="${toxoQuestions}"/>
  </c:when>
  <c:when test = "${project == 'TriTrypDB'}">
    <imp:queryList columns="${columns}" questions="${tritrypQuestions}"/>
  </c:when>
</c:choose>
    
</table></center>

</div>


