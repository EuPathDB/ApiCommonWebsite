<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="random" uri="http://jakarta.apache.org/taglibs/random-1.0" %><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- get wdkModel saved in application scope --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="modelName" value="${wdkModel.displayName}"/>
<c:set var="version" value="${wdkModel.version}"/>
<c:set var="qSetMap" value="${wdkModel.questionSetsMap}"/>

<%-- GENE  --%>
<c:set var="gqSet" value="${qSetMap['GeneQuestions']}"/>
<c:set var="gqMap" value="${gqSet.questionsMap}"/>

<c:set var="geneByIdQuestion" value="${gqMap['GeneBySingleLocusTag']}"/>
<c:set var="gidqpMap" value="${geneByIdQuestion.paramsMap}"/>
<c:set var="geneIdParam" value="${gidqpMap['single_gene_id']}"/>

<c:set var="geneByTextQuestion" value="${gqMap['GenesByTextSearch']}"/>
<c:set var="gkwqpMap" value="${geneByTextQuestion.paramsMap}"/>
<c:set var="textParam" value="${gkwqpMap['text_expression']}"/>
<c:set var="orgParam" value="${gkwqpMap['text_search_organism']}"/>


<c:choose>
	<c:when test="${fn:containsIgnoreCase(modelName, 'ApiDB')}">
		<c:set var="listOrganisms" value="Cryptosporidium hominis,Cryptosporidium parvum,Giardia lamblia, Plasmodium berghei,Plasmodium
 chabaudi,Plasmodium falciparum,Plasmodium knowlesi,Plasmodium vivax,Plasmodium yoelii,Toxoplasma gondii, Trichomonas vaginalis"/>
	</c:when>
        <c:when test="${fn:containsIgnoreCase(modelName, 'CryptoDB')}">
		<c:set var="listOrganisms" value="Cryptosporidium hominis,Cryptosporidium parvum"/>
	</c:when>
<c:when test="${fn:containsIgnoreCase(modelName, 'ToxoDB')}">
                <c:set var="listOrganisms" value="Toxoplasma gondii"/>
        </c:when>

	<c:when test="${fn:containsIgnoreCase(modelName, 'PlasmoDB')}">
		<c:set var="listOrganisms" value="Plasmodium berghei,Plasmodium chabaudi,Plasmodium falciparum,Plasmodium knowlesi,Plasmodium v
ivax,Plasmodium yoelii"/>
	</c:when>
 <c:when test="${fn:containsIgnoreCase(modelName, 'GiardiaDB')}">
		<c:set var="listOrganisms" value="Giardia lamblia"/>
	</c:when>
 <c:when test="${fn:containsIgnoreCase(modelName, 'TrichDB')}">
		<c:set var="listOrganisms" value="Trichomonas vaginalis"/>
	</c:when>

</c:choose> 



	  <div id="half_right">
          <html:form method="get" action="/processQuestionSetsFlat.do">
          <label>Keyword Search:
          <input type="hidden" name="questionFullName" value="GeneQuestions.GenesByTextSearch">
          <input type="hidden" name="myMultiProp(${orgParam.name})" value="${listOrganisms}">
          <input type="hidden" name="myMultiProp(text_fields)"
               value="Gene product,Gene notes,User comments,Protein domain names and descriptions,EC descriptions,GO terms and definitions">
          <input type="hidden" name="myMultiProp(whole_words)" value="no">
          <input type="hidden" name="myProp(max_pvalue)" value="-30">
          <html:text property="myProp(GeneQuestions_GenesByTextSearch_${textParam.name})" value="${textParam.default}"/>
          </label>
          <input type="hidden" name="questionSubmit" value="Get Answer">
	  <input name="go" value="go" type="image" src="/assets/images/mag_glass.png" width="23" height="23" class="img_align_middle" >
          </html:form>
<%--
	  <form id="form2" name="form1" method="post" action="">
          <label>Text Search:
          <input name="Keyword" type="text" class="search-box" id="Keyword" />
          </label>
          <img src="/assets/images/mag_glass.png" alt="SEARCH!" width="23" height="23" class="img_align_middle" />
          </form>
--%>
	  </div>


	  <div id="half_left">
          <html:form method="get" action="/processQuestionSetsFlat.do">
          <label>Gene ID:
          <input type="hidden" name="questionFullName" value="GeneQuestions.GeneBySingleLocusTag">
	  <html:text property="myProp(GeneQuestions_GeneBySingleLocusTag_${geneIdParam.name})" value="${geneIdParam.default}" size="15"/>
          </label>
	  <input type="hidden" name="questionSubmit" value="Get Answer">
	  <input name="go" value="go" type="image" src="/assets/images/mag_glass.png" width="23" height="23" class="img_align_middle" >
          </html:form>

<%--
	  <form id="form1" name="form1" method="post" action="">
          <label>Gene ID:
	  <input name="Gene_ID" type="text" class="search-box" id="Gene_ID" />
          </label>
          <img src="/assets/images/mag_glass.png" alt="SEARCH!" width="23" height="23" class="img_align_middle" />
	  </form>
--%>
          </div>
