<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%-- get wdkModel saved in application scope --%>
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="project" value="${applicationScope.wdkModel.name}" />

<imp:pageFrame title="${wdkModel.displayName} :: Analysis Tools"
               refer="faq"
               banner="Analyze Results"
               parentUrl="/home.jsp">

  <h1>Analyze Your Strategy Results <a href=https://www.youtube.com/watch?v=npgkkychkrI class="new-window"><imp:image src="images/camera.png" width="25px"/></a></h1>
  
  

  <p>Our sites offer tools for analyzing the results of gene searches or strategies. 
  After running a search or strategy that returns genes, you can analyze the results to find 
  statistically enriched Gene Ontology annotations, Metabolic Pathway annotations or words 
  in the gene product descriptions. A term or word is considered enriched if it appears more 
  often in the gene result set than it does in the set of all genes for that organism.  </p>

  <div style="text-align:center">
  
  <imp:image src="images/Overall.jpg" width="400px"/></div>
<br><br>

  <h3> 4 Steps to Analyzing a Search or Strategy Result:</h3>
  <div>
    <ol>
      <li>Start a new search, or open an existing strategy.</li>
      <li>When the search or strategy is loaded, 
      choose the result that you wish to analyze by clicking the 
      strategy box that represents the result. 
         The active result is highlighted in yellow. 
         <div><imp:image src="images/choose_result.jpg" width="350px"/></div></li>
      
       
      <li>Click on the blue "Analyze Results" button. The button appears next to the tabbed results pages.
      
      <div><imp:image src="images/click_button.jpg" width="400px"/></div></li>
      
      <li>Select an analysis tool from the list of available tools. The analysis tool opens in a new tab where you can
      select parameter values for the analysis and click Submit.
      <div><imp:image src="images/choose_analysis.jpg" width="400px"/></div></li>
      
    </ol>
    <em>Not all search results have analysis tools available.</em>
  </div>
<!-- 
  <h3>Video Tutorial</h3>
  <div>
    <em><iframe width="420" height="315" src="//www.youtube.com/embed/npgkkychkrI" frameborder="0" allowfullscreen></iframe></em>
  </div>
   -->
</imp:pageFrame>
