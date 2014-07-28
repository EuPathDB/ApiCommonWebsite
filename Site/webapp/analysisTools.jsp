<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%-- get wdkModel saved in application scope --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="project" value="${applicationScope.wdkModel.name}" />

<imp:pageFrame title="${wdkModel.displayName} :: Analysis Tools"
               refer="faq"
               banner="Analyze Results"
               parentUrl="/home.jsp">

  <h1>Learn About Our Results Analyzer</h1>

  <p>@PROJECT_ID@ offers tools for analyzing gene search results. <br>
  After running a search or strategy that returns genes, you can analyze the result to find 
  statistically enriched Gene Ontology annotations, Metabolic Pathway annotations or words 
  in the gene product descriptions. A term or word is considered enriched if it appears more 
  often in the gene result set than it does in the set of all genes for that organism.  </p>

  <div><img src="/assets/images/overall.jpg"/></div>

  <h3>How to create an Analysis</h3>
  <div>
    <ol>
      <li>Start a new search, or open an existing strategy.</li>
      <li>When the strategy is loaded, 
      choose the result and organism that you wish to analyze. 
      <ol>
         <li>To choose the result you wish to analyze, click the box in the strategy panel that represents the result you wish to analyze
         
         <div><img src="/assets/images/choose_result.jpg"/></div></li>
         
         <li>If your result contains genes from more than one organism, use the filter table to limit the result to genes from a single organism.
         
         <div><img src="/assets/images/choose_organism.jpg"/></div></li>
      </ol>
       </li>
      <li>Click on the blue "Analyze Results" button. The button appears next to the tabbed results pages.</li>
      <li>Select an analysis tool from the list of available tools.</li>
    </ol>
    <em>Not all search results have analysis tools available.</em>
  </div>

  <h3>Video Tutorial</h3>
  <div>
    <em>Embedded YouTube video here</em>
  </div>
</imp:pageFrame>
