<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="project" value="${applicationScope.wdkModel.name}" />
<c:set var="baseUrl" value="${pageContext.request.contextPath}"/>

<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />

<imp:pageFrame title="${wdkModel.displayName} :: MaHPIC">

  <%--
  The following style and script tags are used for the "Read More" functionality.
  The expected structure is:

    .item
      .read_more
      .more_text

  --%>

  <style>
    .item .more_text {
      display: none;
    }
  </style>

  <script>
    jQuery(function($) {
      $('.item').on('click', '.read_more', function(event) {
        event.preventDefault();
        $(event.delegateTarget).find('.more_text').toggle(0, function() {
          $(event.target).text($(this).is(':visible') ? 'Read Less...' : 'Read More...');
        });
      });
    });
  </script>


<h1>Access Data from MaHPIC -<br>The Malaria Host-Pathogen Interaction Center</h1>
<center><div style="font-size:16px">NIAID Contract: # HHSN272201200031C<br>
  <a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC Info at Emory</a> &nbsp; &nbsp; &ndash; &nbsp; &nbsp; <a href="https://www.niaid.nih.gov/research/malaria-host-pathogen-interaction-center-mahpic">MaHPIC Info at NIH</a>&nbsp; &nbsp; &ndash; &nbsp; &nbsp;<a href="#DataLinks">Take me to Exp Info and Data Links</a></div>
  </center> 
        
  <center> <img align="middle" src="images/MaHPIC_TopCenter_4.png" height="150px" width="675px"></center><br><br>

<div class="item">

  <h3>An Introduction to MaHPIC</h3>

  <div style="margin-left: 1em;">
    <a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC</a> is an 
    <a href="https://www.niaid.nih.gov/">NIAID</a>-funded initiative to characterize host-pathogen interactions during malaria 
    infections of non-human primates. 
    <a href="http://www.systemsbiology.emory.edu/research/cores/index.html">MaHPIC's 8 teams</a> of 
    <a href="http://www.systemsbiology.emory.edu/people/investigators/index.html">outstanding scientists</a> 
    use a "systems biology" approach to study the molecular details of how malaria parasites 
	  interact with their human and other animal hosts to cause disease.
    <a href="#" class="read_more">Read More...</a><br><br>
  
  
  
     <span class="more_text">
      MaHPIC's experimental infections are carefully planned and monitored, producing results data sets (clinical 
      and a wide range of omics) that will be made available to the public. Results datasets will offer unprecedented 
      detail on disease progression, recrudescence, relapse, and host susceptibility and will be instrumental in 
      the development of new diagnostics, drugs, and vaccines to reduce the global suffering caused by this disease.<br><br>


	  MaHPIC was established in September 2012 by the 
	  National Institute of Allergy and Infectious Diseases, 
	  part of the US National Institutes of Health. The MaHPIC team uses a "systems biology" strategy to study how malaria parasites 
	  interact with their human and other animal hosts to cause disease in molecular detail. The central hypothesis is that 
	  "Non-Human Primate host interactions with Plasmodium pathogens as model systems will provide insights into mechanisms, 
	  as well as indicators for, human malarial disease conditions".
	  <p>
	  The MaHPIC effort includes many teams working together to produce and analyze data and metadata.  These teams are briefly described below 
	  but more detailed information can be found at 
	  <a href="http://www.systemsbiology.emory.edu/research/cores/index.html">Emory's MaHPIC site</a>. 
	
	<!--
	   <ul>
	    <li>Clinical Malaria - designs and implements experimental plans involving infection of non-human primates</li>
	    <li>Functional Genomics - develops gene expression profiles from blood and bone marrow </li>
	    <li>Proteomics - develops detailed proteomics profiles from blood and bone marrow</li>
	    <li>Lipidomics - investigates lipids and biochemical responses associated with lipids from blood and bone marrow</li> 
	    <li>Immunology - determines immune profiles of peripheral blood and bone marrow in the course of malaria infections of non-human primates. </li>
	    <li>Metabolomics - provides detailed metabolomics data for plasma and associated cellular fractions</li>
	    <li>Bioinformatics - standardizes, warehouses, maps and integrates the data generated by the experimental cores</li>
	    <li>Computational Modeling - integrates the data sets generated by the experimental cores into static and dynamic models.</li>
	   </ul>
	   -->
	   
      	<div style="margin-left: 3em;">
        <img src="images/MaHPIC_Malaria_Core.jpg" height="13px" width="13px">
        Clinical Malaria - designs and implements experimental plans involving infection of non-human primates<br>
        <img src="images/MaHPIC_Functional_Genomics_Core.jpg" height="13px" width="13px">
        Functional Genomics - develops gene expression profiles from blood and bone marrow <br>
        <img src="images/MaHPIC_Proteomics_Core.jpg" height="13px" width="13px">
        Proteomics - develops detailed proteomics profiles from blood and bone marrow<br>
        <img src="images/MaHPIC_Lipidoimics_Core.jpg" height="13px" width="13px">
        Lipidomics - investigates lipids and biochemical responses associated with lipids from blood and bone marrow<br>
        <img src="images/MaHPIC_Metabolomics_Core.jpg" height="13px" width="13px">
        Metabolomics - provides detailed metabolomics data for plasma and associated cellular fractions<br>
        <img src="images/MaHPIC_Informatics_Core.jpg" height="13px" width="13px">
        Bioinformatics - standardizes, warehouses, maps and integrates the data generated by the experimental cores<br>
        <img src="images/MaHPIC_Metabolomics_Core.jpg" height="13px" width="13px">
        Computational Modeling - integrates the data sets generated by the experimental cores into static and dynamic models<br>
        
        
        </div>
        </span>
   </div>
</div>



   
<div class="item">  
   <h3>Systems Biology and Experimental Strategy</h3>
   
   <div style="margin-left: 1em;">
     For the study of malaria in the context of the MaHPIC project, �systems biology� means collecting and analyzing comprehensive data on 
     how a <i>Plasmodium</i> parasite infection produces changes in host and parasite genes, proteins, lipids, the immune response and metabolism.
     MaHPIC experiments are longitudinal studies of <i>Plasmodium</i> infections (or uninfected controls) in non-human primates. 
     <a href="#" class="read_more">Read More...</a><br>
   
     <span class="more_text">
       <img align="middle" src="images/MaHPIC_Generic_Timeline.png" height="260px" width="520px"><br><br>
       <a href="images/MaHPIC_Generic_Timeline.png">View Larger Image</a>
       
       The MaHPIC strategy is to collect physical specimens from non-human primates (NHPs) over the course of an experiment.  The clinical parameters 
       of infected animals and uninfected controls are monitored daily for about 100 days. During the experiment, animals receive blood-stage 
       treatments that clear parasites from the blood but not the liver, which is the source of relapse.  Animals receive a curative treatment 
       at the end of the experiment. At specific milestones during disease progression, blood and bone marrow samples are collected and 
       analyzed by the MaHPIC teams and a diverse set of data and metadata are produced.
 
	 </span>
   </div>	
</div>

<div class="item">

   <h3>The PlasmoDB-MaHPIC Interface Makes MaHPIC Data Available</h3>
   
   <div style="margin-left: 1em;">
     PlasmoDB serves as a gateway for the scientific community to access MaHPIC data. The <a href="#access">MaHPIC Experiment Information and Data Links</a> 
     section of this page provides information about and links to all available MaHPIC data.
     <a href="#" class="read_more">Read More...</a><br><br>
   
      <span class="more_text">
      <img align="middle" src="images/MaHPICtoPlasmo_Interface.png" height="260px" width="520px">
      <a href="images/MaHPICtoPlasmo_Interface.png">View Larger Image</a><br><br>
        The MaHPIC project produces large amounts 
       of data, both clinical and omics, that is stored in public repositories whenever possible. When an appropriate public 
       repository does not exist (e.g. clinical data and metadata), PlasmoDB stores the data in our Downloads Section. Results 
       include a rich collection of data and metadata collected over the course of 
       individual MaHPIC experiments. Each Clinical Malaria data set consists of a set of files, including a descriptive README, that contain clinical, 
       veterinary, and animal husbandry results from a MaHPIC Experiment.  The results produced by the MaHPIC Clinical Malaria Team are the 
       backbone of MaHPIC experiments.<br><br>
     </span>
  </div>
</div>


  <h3 id="DataLinks">MaHPIC Experiment Information and Data Links</h3>
  <div style="margin-left: 1em;">	
   
   <div class="wdk-toggle" data-show="false">
      <h4 class="wdk-toggle-name"><a href="#">Experiment 4</a></h4>
   <div class="wdk-toggle-content">
   
    <img align="middle" src="images/MaHPIC_Ex04_Timeline.png" height="300px" width="500px">
    <a href="images/MaHPIC_Ex04_Timeline.png">View Larger Image</a>
    
     <h4>Experiment Information</h4>
	 <ul>
	  <li><b>Title:</b> Five <i>Macaca mulatta</i> individuals infected with <i>Plasmodium cynomolgi</i> B strain and 
      treated with artemether over a 100-day study to observe multiple disease relapses.</li>
	  <li><b>Experiment Description:</b> The experimental design of this <i>Plasmodium cynomolgi</i> B strain infection of <i>Macaca mulatta</i> was approved by the Emory University Institutional Animal Care and Use Committee (IACUC) and is as follows. Five naive males (RFa14, RFv13, Rlc14, RMe14, RSb14) approximately 2 years of age were inoculated intravenously with a preparation of Anopheles dirus salivary gland material that included malaria sporozoites and then profiled for clinical and omic measurements over the course of a 100-day experiment. The drug Artemether was administered to subjects during the 100-day experiment.   Samples were generated and analyzed as part of a multi-omic approach to understanding at the molecular level the course and effects of infection and relapse on both host and parasite.  Samples were generated daily and at an additional 7 time points over the experiment.  The drugs chloroquine and primaquine were administered to subjects at the end of the 100-day experiment.</li>
	  <li><b>MaHPIC's Read Me:</b> <a href="http://plasmodb.org/common/downloads/MaHPIC/E04ClinicalMalaria/E04M99MEMmCyDaWB_07122016-README_MULTIPL.txt">E04 READ ME (Text file)</a></li>
	  <li><b>Experimental Details File:</b> <a href="http://plasmodb.org/common/downloads/MaHPIC/E04ClinicalMalaria/EX04_Sub_Template.xlsx">Submission Template (Excel file)</a></li>
	  
	 </ul> 
	 <h4>Data Links</h4> 
	   <!--
	   <ul>
	    <li><b>Clinical Malaria Results:</b> Coming Soon <!--<a href="http://plasmodb.org/common/downloads/MaHPIC/E04ClinicalMalaria/">PlasmoDB Downloads (Exp04)</a> AND 
	                          <a href="http://plasmodb.org/common/downloads/MaHPIC/E04ClinicalMalaria/EX04_Sub_Template.xlsx#Sheet5!A1:B15">File Descriptions</a>--></li>
	    <li><b>Functional Genomics Results:</b> Coming Soon <!--<a href="https://www.ncbi.nlm.nih.gov/sra" target="_blank" >Sequence data at SRA</a>  OR  <a href=" https://www.ncbi.nlm.nih.gov/geo/" target="_blank">Expression data at GEO--></a> </li>
	    <li><b>Proteomics Results:</b> Coming Soon <!--<a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Exp04 Proteomics data at MassIVE</a>  OR  <a href=" https://www.ebi.ac.uk/pride/archive/" target="_blank">Exp04 data at PRIDE--></a></li>
	    <li><b>Lipidomics Results:</b> Coming Soon <!--<a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Exp04 Lipidomics data at MassIVE</a>--></li> 
	    <li><b>Immunology Results:</b> Coming Soon <!--<a href="https://immport.niaid.nih.gov/immportWeb/home/home.do?loginType=full" target="_blank">Exp04 Immunomics at ImmPort</a>--></li>
	    <li><b>Metabolomics Results:</b> Coming Soon <!--<a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Exp04 Metabolomics data at MassIVE</a>--></li>
	    <li><b>Computational Modeling Results:</b> Coming Soon </li>
	   </ul>
	   -->
	   <div style="margin-left: 3em;">
        <img src="images/MaHPIC_Malaria_Core.jpg" height="13px" width="13px">
        <b>Clinical Malaria</b> - Coming Soon <br>
        <img src="images/MaHPIC_Functional_Genomics_Core.jpg" height="13px" width="13px">
        <b>Functional Genomics</b> - Coming Soon <br>
        <img src="images/MaHPIC_Proteomics_Core.jpg" height="13px" width="13px">
        <b>Proteomics</b> - Coming Soon<br>
        <img src="images/MaHPIC_Lipidoimics_Core.jpg" height="13px" width="13px">
        <b>Lipidomics</b> - Coming Soon<br>
        <img src="images/MaHPIC_Metabolomics_Core.jpg" height="13px" width="13px">
        <b>Metabolomics</b> - Coming Soon<br>
        <img src="images/MaHPIC_Informatics_Core.jpg" height="13px" width="13px">
        <b>Bioinformatics</b> - Coming Soon<br>
        <img src="images/MaHPIC_Metabolomics_Core.jpg" height="13px" width="13px">
        <b>Computational Modeling</b> - Coming Soon<br>
	   
	   
	   
	   
	 <h4>Publication</h4>
	 <ul>
	   <li><a href="https://www.ncbi.nlm.nih.gov/pubmed/27590312" target="_blank">Joyner et al. Malar J. 2016 Sep 2;15(1):451.</a></li>  
	 </ul>
  </div>
  </div>	
  
     <div class="wdk-toggle" data-show="false">
     <h4 class="wdk-toggle-name"><a href="#">Experiment 13: Coming Soon</a></h4>
     <div class="wdk-toggle-content">
  </div>
  </div>
  
  </div>

</imp:pageFrame>
