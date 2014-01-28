<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>

    <!-- needed for CYTOSCAPE start -->
    <!-- JSON support for IE (needed to use JS API) -->
	<script type="text/javascript" src="/js/json2.min.js"></script>
        
     <!-- Flash embedding utility (needed to embed Cytoscape Web) -->
     <script type="text/javascript" src="/js/AC_OETags.min.js"></script>
        
     <!-- Cytoscape Web JS API (needed to reference org.cytoscapeweb.Visualization) -->
     <script type="text/javascript" src="/js/cytoscapeweb.min.js"></script>
        
     <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script> 



    <!-- needed for CYTOSCAPE end -->

<%/* get wdkRecord from proper scope */%>
<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set var="attrs" value="${wdkRecord.attributes}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="recordName" value="${wdkRecord.recordClass.displayName}" />
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="id" value="${pkValues['source_id']}" />
<c:set var="projectIdLowerCase" value="${fn:toLowerCase(projectId)}"/>
<c:set var="pathwayImageId" value="${attrs['image_id'].value}" />
<c:set var="pathwayName" value="${attrs['description'].value}" />

<imp:pageFrame title="${wdkModel.displayName} : Met Pathway ${id}"
             refer="recordPage"
             banner="Met Pathway ${id}"
             divisionName="${recordName} Record"
             division="queries_tools">

<c:choose>
  <c:when test="${!wdkRecord.validRecord}">
    <h2 style="text-align:center;color:#CC0000;">The ${recordName} '${id}' was not found.</h2>
  </c:when>
<c:otherwise>

<%-- quick tool-box for the record --%>
<imp:recordToolbox />


<div class="h2center" style="font-size:160%">
 	Metabolic Pathway
</div>

<div class="h3center" style="font-size:130%">
	${id} -  ${pathwayName}<br>
	<imp:recordPageBasketIcon />
</div>


<%--#############################################################--%>

<c:set var="append" value="" />

<c:set var="attr" value="${attrs['overview']}" />
<imp:panel 
    displayName="${attr.displayName}"
    content="${attr.value}" 
    attribute="${attr.name}"/>

<br>
<%--
<br>
<div align="center">
<img align="middle" src="/cgi-bin/colorKEGGmap.pl?model=${projectId}&pathway=${id}" usemap="#pathwayMap"/>
<imp:pathwayMap projectId="${projectId}" pathway="${id}" />
</div>
<br>

<iframe  src="<c:url value='/pathway-dynamic-view.jsp?model=${projectId}&pathway=${id}' />"  width=100% height=800 align=middle>
</iframe> 
--%>


<!-- CYTOSCAPE start-->
     <script type="text/javascript">
     window.onload=function() {
	 // id of Cytoscape Web container div
	 var div_id = "cytoscapeweb";
           
	 // initialization options
	 var options = {
	     // where you have the Cytoscape Web SWF
	     swfPath: "/swf/CytoscapeWeb",
	     // where you have the Flash installer SWF
	     flashInstallerPath: "/swf/playerProductInstall"
	 };
                
	 // init and draw
	 var vis = new org.cytoscapeweb.Visualization(div_id, options);
         var presetLayout;

	 // callback when Cytoscape Web has finished drawing
	 vis.ready(function() {

		 // listener for when nodes and edges are clicked
		 vis.addListener("click", "nodes", function(event) {
			 // try "mouseover" OR "click"
			 handle_click(event);
		     });
                    
		 function handle_click(event) {
		     var target = event.target;                         
		     clear();
		     var type = target.data["Type"];

                      if(type == "enzyme") {
				 print ("<b>EC Number:  </b> " + target.data["label"]);
                                 print("");
				 print("<b>Enzyme Name:  </b>" + target.data["Description"]);
                                 print("");

                               if(target.data["Organisms"]) {
                               var orgs =  target.data["Organisms"].split(",");
                               print("<b>Organism(s): </b>");
                               for(var i in orgs.sort()) {
  				 print("&nbsp;&nbsp;" + orgs[i]);        
                              }
                              print("");
                              print("<a href='/a/processQuestion.do?questionFullName=GeneQuestions.InternalGenesByEcNumber&array%28organism%29=all&questionSubmit=Get+Answer&array%28ec_number_pattern%29=" + target.data["label"] + "'>Search for Gene(s) By EC Number</a>");
                              print("");

                              if(target.data.image) {
                                     var link =  target.data.image + '&fmt=png&h=250&w=300' ;
                                     print("<img src='" + link + "'>");
                              }
                              }
                       } 
			 
			 if(type == "compound") {
                                 print("<b>Compound ID:</b>  " + target.data["label"] + "<br />");

                                 if(target.data.Description) {
                                 print("<b>Name:</b>  " + target.data["Description"] + "<br />");
                                 }
				 print ("<a href='http://www.genome.jp/dbget-bin/www_bget?" + target.data["label"] + "'>View in KEGG</a>");

			     if(target.data["CID"]) {
				 print("<a href='/a/showRecord.do?name=CompoundRecordClasses.CompoundRecordClass&project_id=PlasmoDB&source_id=CID:" + target.data["CID"] + "'>View in PlasmoDB</a>");
			     }
			     if(target.data["SID"]) {
				 print("<a href='http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?sid=" + target.data["SID"] + "'>View on NCBI</a>");
				 print("<img src='http://pubchem.ncbi.nlm.nih.gov/image/imgsrv.fcgi?t=l&sid=" + target.data["SID"] + "'>");
			     }

			 }

			 if(type == "map") {

			     print("<b>Pathway:  </b>" + "<a href='/a/showRecord.do?name=PathwayRecordClasses.PathwayRecordClass&project_id=PlasmoDB&source_id=" + target.data["Description"] + "'>" + target.data["label"] + "</a>");
                             print("");
			     print("<a href='http://www.genome.jp/dbget-bin/www_bget?" + target.data["Description"] + "'>View in KEGG</a>");
			 }
		 }
                    
		 function clear() {
		     document.getElementById("draggable").innerHTML = "";
		 }
		 
		 function print(msg) {
		     document.getElementById("draggable").innerHTML += msg + "<br />";
		 }

		 // customTooltip function
		 vis["customTooltip"] = function (data) {
		     //  var value = Math.round(100 * data["weight"]) + "%";
		     var value = data["label"];
		     if (data["Description"]) {
			 value  = value +  ": " + data["Description"] ;
		     }
		     //if (data["Organisms"]) {
			 //value  = value + "\nOrganisms: " + data["Organisms"];
		     //}
		     return (value);
		 };

		 // customBorder function : if node has Organisms, then border should be a different color
		 vis["customBorder"] = function (data) {
		     var value = data["label"];
		     if (data["Organisms"]) {
			 value  = "#FF0000";
		     } else {
		       value = "#000000";
		     }		       	     
		     return (value);
		 };

		 var colorMapper = {
		     attrName: "Type",
		     entries: [ { attrValue: "map", value: "#ccffff" },
		                { attrValue: "enzyme", value: "#ffffcc" },
		                { attrValue: "compound", value: "#0000ff" } ]
		 };
		 
		 var shapeMapper = {
		     attrName: "Type",
		     entries: [ { attrValue: "map", value: "ROUNDRECT" },
		                { attrValue: "enzyme", value: "SQUARE" },
		                { attrValue: "compound", value: "CIRCLE" } ]
		 };

		 var sizeMapper = {
		     attrName: "Type",
		     entries: [ { attrValue: "map", value: 'auto' }]
		 };

		 var widthMapper = {
		     attrName: "Type",
		     entries: [ { attrValue: "enzyme", value: 50 },
		                { attrValue: "compound", value: 15 } ]
		 };

		 var heightMapper = {
		     attrName: "Type",
		     entries: [{ attrValue: "map", value: 20 },
		                { attrValue: "enzyme", value: 20 },
		                { attrValue: "compound", value: 15 } ]
		 };

		 var labelPosition = {
		     attrName: "Type",
		     entries: [{attrValue: "compound", value: 'right' } ]
		 };

		 var labelSize = {
		     attrName: "Type",
		     entries: [{ attrValue: "compound", value: 0 } ],
		 };

		 // to not show arrowhead for a Reversible reaction
		 var edgeArrow= {
		     attrName: "direction",
		     entries: [{ attrValue: "Reversible", value: "NONE" },
		                   { attrValue: "Irreversible", value: "DELTA" }  ]
		 };


var style = {
        nodes: {
  	  color: { discreteMapper: colorMapper }, 
  	  shape: { discreteMapper: shapeMapper }, 
  	  width : { discreteMapper: widthMapper }, 
  	  size : { discreteMapper: sizeMapper }, 
  	  height : { discreteMapper: heightMapper }, 
	  borderColor : { customMapper: { functionName:  "customBorder" } }, 
          borderWidth : 1,
	  tooltipText : {customMapper:  { functionName: "customTooltip" } },
	  labelFontSize : { discreteMapper: labelSize },
        },
        edges: {
  	  color :"#000000", width: 1, 
  	  targetArrowShape:  { discreteMapper: edgeArrow  },
	}
};

     // I need a node attribute to store the image
     var field = { name: "image", type: "string", defValue: "" };
     vis.addDataField("nodes", field);

     vis.nodeTooltipsEnabled(true);
     vis.visualStyle(style);

   changeExperiment = function(val) {
     // use bypass to hide labelling of EC num that have heatmap graphs
    var nodes = vis.nodes();  

     for (var i in nodes) {
	 var n = nodes[i];

         var type =  n.data.Type;

         if(type == ("enzyme") && n.data.Organisms) {
           var ecNum = n.data.label;

           if(val) {
               var linkPrefix = '/cgi-bin/dataPlotter.pl?idType=ec&' + val + '&id=' + ecNum;
                var link =  linkPrefix + '&fmt=png&h=20&w=50&compact=1' ;

               style.nodes[n.data.id] = {image:  link,  label: ""}
               n.data.image = linkPrefix;
           } else {
               style.nodes[n.data.id] = {image:  ""};
               n.data.image = "";
          }
        vis.updateData([n]);
     }
  }

   vis.nodeTooltipsEnabled(true);
   vis.visualStyleBypass(style);
   };

   changeLayout = function(val) {
      var current = vis.layout();
      if(current.name == "Preset") {
         presetLayout = current;
      }

      if(val == "Preset") {
          vis.layout(presetLayout);
      }
      else {
        vis.layout(val);
     }    

  };


  // set the style programmatically
   document.getElementById("color").onclick = function(){
      vis.visualStyleBypass(style);
   };


     // end ready
});




	 $.ajax({
                 url: "/cytoscape/${id}.xgmml",
		     dataType: "text",
		     success: function(data){
		     vis.draw(options);
		      vis.draw({ network: data , layout: 'Preset',
		     		 });
		   },
		  error: function(){
		  alert("Error loading file");
		  }
	     });
     };

</script>        
    <style>
            /* The Cytoscape Web container must have its dimensions set. */
            html, body { height: 100%; width: 100%; padding: 0; margin: 0; }
            #cytoscapeweb { width: 100%; height: 100%; }
            .link { text-decoration: underline; color: #0b94b1; cursor: pointer; }
        </style>


     <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.js" type="text/javascript"></script>
      <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/wdkCustomization/css/jsddm/jsddm.css"/>
      <script type="text/javascript" src="${pageContext.request.contextPath}/wdkCustomization/js/lib/jsddm.js"><jsp:text/></script>



 <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
 <style>
#draggable {z-index:1000;margin-left:18px;position:absolute;margin-top: 400px; background-color:white;border:1px solid black; border-radius:5px; width: 300px; padding: 0.5em; }
#cytoscapeweb { border:1px solid black; border-radius:5px;  }
</style>
<script>
$(function() {
$( "#draggable" ).draggable();
});
</script>



        <div id="draggable" style="">
            <p>Click on nodes or edges for more info.  We have highlighed enzyme nodes in <font color="red">red</font> where we have mappped the EC Number to at least one Gene ID.   You can drag this box around to if the image is too large.</p>
<br />
        </div>


<ul id="jsddm">
    <li><a href="javascript:void(0)">Layout</a>
        <ul>
            <li><a  href="javascript:void(0)" onclick="changeLayout('Preset')">Kegg</a></li>
            <li><a  href="javascript:void(0)" onclick="changeLayout('ForceDirected')">ForceDirected</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Tree')">Tree</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Circle')">Circle</a></li>
            <li><a href="javascript:void(0)" onclick="changeLayout('Radial')">Radial</a></li>
        </ul>
    </li>
    <li><a href="#">Paint Expt.</a>
        <ul>
            <li><a href="javascript:void(0)" onclick="changeExperiment('')">Default</a></li>
<c:set value="${wdkRecord.tables['PathwayGraphs']}" var="pathwayGraphs"/>
<c:forEach var="row" items="${pathwayGraphs}">
            <li><a href="javascript:void(0)" onclick="changeExperiment('${row['internal'].value}')">${row['display_name'].value}</a></li>
</c:forEach>
        </ul>
    </li>
</ul>

        <div id="cytoscapeweb">
            Cytoscape Web will replace the contents of this div with your graph.
        </div>

<br />
<br />
<br />

<!-- CYTOSCAPE end-->



<%-- Reaction Table ------------------------------------------------%>
  <imp:wdkTable tblName="CompoundsMetabolicPathways" isOpen="true"/>

</c:otherwise>
</c:choose>


  <c:set var="reference">
 <br>Data for Metabolic Pathways were procured from the <a href="http://www.kegg.jp/">Kyoto Encyclopedia of Genes and Genomes (KEGG)</a>.<br>
 This data was mapped to EC Numbers obtained from <a href="<c:url value='/getDataset.do?display=detail#Genomes and Annotation'/>">the official genome annotations of organisms</a>, and Compounds from the NCBI repository.<br>
 The images and maps for KEGG pathways are copyright of <a href="http://www.kanehisa.jp/">Kanehisa Laboratories</a>.
Coloring of the KEGG maps was performed in house with custom scripts and annotation information.<br>
  </c:set>
<br>
<br>

<imp:panel 
    displayName="Data Source"
    content="${reference}" />
<br>

<%------------------------------------------------------------------%>

<hr>


</imp:pageFrame>

