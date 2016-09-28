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
        $(event.delegateTarget).find('.more_text').toggle();
      });
    });
  </script>

<h1>Access Data from MaHPIC -<br>The Malaria Host-Pathogen Interaction Center</h1>
<center><a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC Info at Emory</a> &nbsp; &nbsp; &ndash; &nbsp; &nbsp; <a href="https://www.niaid.nih.gov/research/malaria-host-pathogen-interaction-center-mahpic">MaHPIC info at NIH</a></center>
<h2>An Introduction to MaHPIC</h2>
<div style="margin-left: 1em;">


<div class="item">

  <h3>What is MaHPIC?</h3><br>
  <a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC</a> is an 
  <a href="https://www.niaid.nih.gov/">NIAID</a>-funded initiative to characterize host-pathogen interactions during malaria 
  infections of non-human primates. READ MORE
  <a href="#" class="read_more">Read More...</a><br><br>
  
  <span class="more_text">
     MaHPIC's experimental infections are carefully planned and monitored, producing publicly available data sets (clinical and 
     a wide range of omics) that
     address disease progression, recrudescence, relapse, host susceptibility and co-infections. These data sets can be used to 
     develop new diagnostics, drugs and vaccines to reduce the global suffering caused by this disease.<br><br>

    <section>
	The <a href="http://www.systemsbiology.emory.edu/index.html">Malaria Host-Pathogen Interaction Center (MaHPIC)</a> was established 
	in September 2012 by the 
	<a href="https://www.niaid.nih.gov/research/malaria-host-pathogen-interaction-center-mahpic">National Institute of Allergy and Infectious Diseases</a>, 
	part of the US National Institutes of Health. The MaHPIC team uses a "systems biology" strategy to study how malaria parasites 
	interact with their human and other animal hosts to cause disease in molecular detail. The central hypothesis is that 
	"Non-Human Primate host interactions with Plasmodium pathogens as model systems will provide insights into mechanisms, 
	as well as indicators for, human malarial disease conditions".
	<p>
	The MaHPIC effort includes many teams working together to produce and analyze data and metadata.  These teams are briefly described below 
	<a href="http://www.systemsbiology.emory.edu/research/cores/index.html">(detailed information)</a>: 
	
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
	</section>
  </span>	

</div>
</div>


<div class="item">

   <h3>What is the MaHPIC-PlasmoDB Interaction?</h3><br>
   PlasmoDB serves as a gateway for the scientific community to access MaHPIC data. READ MORE<br><br>
   <a href="#" class="read_more">Read More...</a><br><br>
   
     <span class="more_text">
     <img align="middle" src="images/MaHPICtoPlasmo.png" height="300px" width="520px"><br><br>
   
     The MaHPIC project produces large amounts of data, both clinical and omics.  MaHPIC data is stored in public repositories whenever possible 
     (e.g. <a href="https://www.ncbi.nlm.nih.gov/sra">NCBI's Sequence Read Archive</a> for RNA Sequencing). When an appropriate public 
     repository does not exist (e.g. clinical data and metadata), PlasmoDB stores the data in our Download Section.  The Access Data section 
     of this page provides links to all available MaHPIC data. <br><br>
   
     As part of the MaHPIC�s data deposition effort, data sets composed of experimental results from the Clinical Malaria team are 
     hosted at PlasmoDB and HostDB.  Results include a rich collection of data and metadata collected over the course of 
     individual MaHPIC experiments. Each �data set� consists of a set of files, including a descriptive README, that contain clinical, 
     veterinary, and animal husbandry results from a MaHPIC Experiment.  The results produced by the MaHPIC Clinical Malaria Team are the 
     backbone of MaHPIC experiments.<br><br>
     </span>
</div>

   
<div class="item">  
   <h3> MaHPIC Experimental Design </h3><br>
   MaHPIC experiments are longitudinal studies of Plasmodium infections (or uninfected controls) in non-human primates designed to elucidate 
   host-pathogen interactions and address disease progression, recrudescence, relapse, host susceptibility and co-infections. 
   <a href="#" class="read_more">Read More...</a><br><br> 
   
     <span class="more_text">
     <img align="middle" src="images/MaHPIC_Generic_Timeline.png" height="260px" width="520px"><br><br>
   
     The MaHPIC strategy is to collect physical specimens from non-human primates (NHPs) over the course of an experiment.  The clinical parameters 
     of infected animals and uninfected controls are monitored daily for about 100 days. During the experiment, animals receive blood-stage 
     treatments that clear parasites from the blood but not the liver which is the source of relapse.  Animals receive a curative treatment 
     at the end of the experiment. At specific milestones during disease progression, blood and bone marrow samples are collected and 
     analyzed by the MaHPIC teams and a diverse set of data and metadata are produced.
 
	
	<!--<section>
	The MaHPIC strategy is to collect physical specimens from non-human primates (NHPs) over the course of an experiment.  Experiments are usually 
	planned for 100 day periods.  In addition to uninfected control experiments, NHPs are infected with Plasmodium parasites and physical samples 
	are collected either daily or at specific time points, depending on the specimen type (blood, bone marrow, etc) as the infection progresses.  
	Samples are then analyzed by the MaHPIC teams and a diverse set of data and metadata are produced.  
	</section>
	-->
	</span>
</div>	


<div class="item"> 

   <h3>Which MaHPIC Data are Available?</h3><br>
   Need text here
   <a href="#" class="read_more">Read More...</a><br><br> 
    
     <span class="more_text">

	 As part of the MaHPIC's data deposition effort, datasets composed of experimental results from the Clinical Malaria team are being hosted 
	 at PlasmoDB and HostDB.  Results include a rich collection of data and metadata collected over the course of individual MaHPIC experiments. 
	 Each �dataset� consists of a set of files, including a descriptive README, that contain clinical, veterinary, and animal husbandry results 
	 from a MaHPIC Experiment.  The results produced by the MaHPIC Malaria Core are the backbone of MaHPIC experiments.<br><br>
	 The list of available datasets, publications, and associated data in other public repositories shown below will be updated!
     </span>
</div>


  <h3>MaHPIC Experiments</h3>
  <div style="margin-left: 1em;">	
   
   <div class="wdk-toggle" data-show="false">
   <h4 class="wdk-toggle-name"><a href="#">Experiment 4</a></h4>
   <div class="wdk-toggle-content">
   

    <section>
    For MaHPIC Experiment 04, 5 Rhesus macaques (Macacca mulatta) were infected with <i>Plasmodium cynomolgi</i> (B strain) and monitored 
    over a 100-day period. Daily clinical parameters as well as blood bone marrow samples taken at milestones of disease progression 
    were collected.  
    
    <img align="middle" src="images/expt3WF.jpg" height="312px" width="500px">
    
	 <ul>
	  <li>Description of experiment goals</li>
	  <li>Experiment start and end dates</li>
	  <li>Link to dataset at PlasmoDB / HostDB download pages</li>
	  <li>Description of publications including these results</li>
	  <li>Lists of links to other public respositories with data from this Experiment.</li>
	 </ul> 
  </div>
  </div>	

</imp:pageFrame>
