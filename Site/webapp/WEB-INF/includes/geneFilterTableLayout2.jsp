<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<c:set var="answerValue" value="${requestScope.answer_value}"/>
<c:set var="strategyId" value="${requestScope.strategy_id}"/>
<c:set var="stepId" value="${requestScope.step_id}"/>
<c:set var="layout" value="${requestScope.filter_layout}"/>

<!-- DEBUGGING 
- family.values is the count of organisms per family, for family colspan
- sortedInstances contains all filter instances (java objects AnswerFilterInstance) sorted by instance (filter) name, 
   which sets distinct filters before instance filters, for a given species
- instanceCountMap contains {family-species, count of organisms within a species}, for species colspan
   sorted by key, but we do not need the sorting here, just used as map.

		 <c:forEach items="${layout.sortedFamilyCountMap}" var="family" >
			 <br>---${family.key}----${family.value}----<br>
		 </c:forEach>

		 <c:forEach items="${layout.sortedInstances}" var="instance">
			 <c:set var="familySpecies" value="${fn:substringBefore(instance.name,'_')}" />
			 <br>${familySpecies} -----  ${layout.instanceCountMap[familySpecies]} ---- ${instance.name} <br>
		 </c:forEach>

     <c:forEach items="${layout.instanceCountMap}" var="instance">
			 <br>${instance} <br>
		 </c:forEach>
-->

<table>

	<!-- ========================PHYLUM (if provided) and  FAMILY TITLE (includes all and orthologs)  ================ -->
	<!-- ================================================= -->
  <c:choose>

  <c:when test="${fn:length(layout.superFamilyCountMap) > 1 }">
    <tr>
      <th rowspan=4>All<br>Results</th>
      <th rowspan=4>Ortholog<br>Groups</th>
    <c:forEach items="${layout.superFamilyCountMap}" var="phylum" >
      <th colspan="${phylum.value}"><i>${phylum.key}</i></th>
	  </c:forEach>
    </tr>
    <tr>
    <c:forEach items="${layout.sortedFamilyCountMap}" var="family" >
    	<th colspan="${family.value}"><i>${fn:substringAfter(family.key,'-')}</i></th>
 		</c:forEach>
    </tr>
  </c:when>
  <c:when test="${fn:length(layout.superFamilyCountMap) == 1 }" >
    <tr>
      <th rowspan=3>All<br>Results</th>
      <th rowspan=3>Ortholog<br>Groups</th>
 		<c:forEach items="${layout.sortedFamilyCountMap}" var="family" >
    	<th colspan="${family.value}"><i>${fn:substringAfter(family.key,'-')}</i></th>
 		</c:forEach>
    </tr>
  </c:when>
  <c:otherwise>
    <tr>
      <th rowspan=3>All<br>Results</th>
      <th rowspan=3>Ortholog<br>Groups</th>
 		<c:forEach items="${layout.sortedFamilyCountMap}" var="family" >
    	<th colspan="${family.value}"><i>${family.key}</i></th>
 		</c:forEach>
    </tr>
  </c:otherwise>
  </c:choose>

	<!-- ========================= SPECIES TITLE  (if distinct true will generate a gene count) ================ -->
	<!-- ================================================= -->
	<%-- the assumption is that a species with more than one organism HAS one organism as reference strain (by loaders), 
			 SUCH that a distinct filter is generated by the injectors.
			 With this assumption, the first 2 <c:when> cases below would take care of ALL species.
			 With Giardia Assemblage case, in the absence of a distinct filter for a species with more than one organism, 
			 we need to add the third case below.
			 But in order to work we need to sort distinct filters to appear first, so we add _AA_ in their name.
  --%>
  <tr>
		<c:forEach items="${layout.sortedInstances}" var="instance">        
 
     <%-- ONLY PARSING IN THIS FILE, more detailed parsing will be performed in the tag file that generates the row --%> 
			<c:set var="familySpecies" value="${fn:substringBefore(instance.name,'_')}" />

			<c:choose>
				<%-- =============== distinct filter found for a species that has MORE than ONE organism ============== --%>
				<c:when test="${layout.instanceCountMap[familySpecies] ne '1' && 
                      fn:contains(instance.name,'distinct')
											}">
					<th colspan="${layout.instanceCountMap[familySpecies]}">
						<imp:filterInstance2 strategyId="${strategyId}" stepId="${stepId}" answerValue="${answerValue}" 
				 												 instanceName="${instance.name}" 
																 distinct="true"/> 
					</th>
				</c:when>
				<%-- =============== NOT distinct filter found for a species that has ONLY ONE organism ============== --%>
 				<c:when test="${layout.instanceCountMap[familySpecies] == 1 && 
                      !fn:contains(instance.name,'distinct')
											}">
					<th>
						<imp:filterInstance2 strategyId="${strategyId}" stepId="${stepId}" answerValue="${answerValue}" 
																 instanceName="${instance.name}" 
																 titleSpecies="true"/> 
					</th>
				</c:when>
				<%-- =============== a NON distinct filter will be USED for a species that has MORE than ONE organism,
                             ONLY WHEN it does not have a distinct filter generated (no reference strain has been set) ============== --%>
				<c:when test="${layout.instanceCountMap[familySpecies] ne '1' && 
											!fn:contains(instance.name,'distinct') &&  
											!fn:contains(familySpeciesList,fn:trim(familySpecies))  eq 'true' &&
											familySpecies ne 'all' 
											}">
          <th colspan="${layout.instanceCountMap[familySpecies]}">
            <imp:filterInstance2 strategyId="${strategyId}" stepId="${stepId}" answerValue="${answerValue}" 
				 												 instanceName="${instance.name}"  
																 titleSpecies="true"
																 missRefStrain="true" />
          </th>
				</c:when>
			</c:choose>

     <%-- This is used to avoid third case above, when there is already a species title in place --%>
			<c:set var="familySpeciesList" value="${familySpeciesList} ${familySpecies}" />
			<%-- DEBUG 
					 <br>${familySpeciesList}<br>
		  --%>

		</c:forEach>
  </tr>

	<!-- ========================== STRAIN TITLE (total strain count)  ================ -->
	<!-- =================================================== -->

  <tr>
    <c:forEach items="${layout.sortedInstances}" var="instance">         
      <c:set var="familySpecies" value="${fn:substringBefore(instance.name,'_')}" />

    	<c:if test="${familySpecies ne 'all' && !fn:contains(instance.name,'distinct')}" >
        <th>
          <imp:filterInstance2 strategyId="${strategyId}" stepId="${stepId}" answerValue="${answerValue}" 
															 instanceName="${instance.name}" 	
															 titleStrain="true"/> 
        </th>
      </c:if>
    </c:forEach>
  </tr>

	<!-- ==========================  COUNTS (all + orthologs + total strain count)  ================ -->
	<!-- =================================================== -->

  <tr>
    <td>
      <imp:filterInstance2 strategyId="${strategyId}" 
                           stepId="${stepId}" 
                           answerValue="${answerValue}" 
                           instanceName="all_results" />  
    </td>
    <td>
      <imp:filterInstance2 strategyId="${strategyId}" 
                           stepId="${stepId}" 
                           answerValue="${answerValue}" 
                           instanceName="all_ortholog_groups" />  
    </td>

    <c:forEach items="${layout.sortedInstances}" var="instance">         
      <c:set var="familySpecies" value="${fn:substringBefore(instance.name,'_')}" />

	    <c:if test="${familySpecies ne 'all' && !fn:contains(instance.name,'distinct')}" >
        <td>
          <imp:filterInstance2 strategyId="${strategyId}" 
                               stepId="${stepId}" 
                               answerValue="${answerValue}" 
															 instanceName="${instance.name}" /> 
        </td>
      </c:if>
    </c:forEach>
  </tr>

</table>
