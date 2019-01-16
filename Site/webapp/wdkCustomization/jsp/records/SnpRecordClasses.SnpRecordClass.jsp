<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="id" value="${pkValues['source_id']}" />

<c:set var="attrs" value="${wdkRecord.attributes}"/>

<!-----------  SET ISVALIDRECORD  ----------------------------------->
<c:catch var="err">
<%-- force RecordInstance.fillColumnAttributeValues() to run
      and set isValidRecord to false if appropriate. 
      wdkRecord.isValidRecord is tested in the project's RecordClass --%>
<c:set var="junk" value="${attrs['organism']}"/>
<c:set var="snp_position" value="${attrs['location'].value}"/>
<c:set var="start" value="${snp_position-25}"/>
<c:set var="end"   value="${snp_position+25}"/>
<c:set var="sequence_id" value="${attrs['seq_source_id'].value}"/>
<c:if test="${attrs['gene_strand'].value == 'reverse'}">
  <c:set var="revCompOn" value="1"/>
</c:if>
</c:catch>

<imp:pageFrame title="${wdkModel.displayName} : SNP ${id}"
             banner="SNP ${id}"
             refer="recordPage"
             divisionName="SNP Record"
             division="queries_tools">

<c:choose>
<c:when test="${!wdkRecord.validRecord}">
  <h2 style="text-align:center;color:#CC0000;">The SNP '${id}' was not found.</h2>
</c:when>
<c:otherwise>

<%-- quick tool-box for the record --%>
<imp:recordToolbox />


<div class="h2center" style="font-size:160%">
   SNP
</div>

<div class="h3center" style="font-size:130%">
  ${primaryKey}<br>
  <imp:recordPageBasketIcon />
</div>


<!-- Overview -->
<c:set var="attr" value="${attrs['snp_overview']}" />

<imp:panel 
    displayName="${attr.displayName}"
    content="${attr.value}" 
    attribute="${attr.name}"/>

<!-- Gene context -->
<c:set var="attr" value="${attrs['gene_context']}" />

<imp:panel
    displayName="${attr.displayName}" 
    content="${attr.value}" 
    attribute="${attr.name}"/>

<!-- Allele count table -->
<imp:wdkTable tblName="AlleleCount" isOpen="true"/>

<!-- Product count table -->
<imp:wdkTable tblName="ProductCount" isOpen="true"/>

<!-- strains table: for HTS SNPs only -->

<c:set var="start" value="${attrs['location_text']}"/>
<c:set var="alignment_start" value="${fn:replace(start,',','') - 39}" /> </h4>
<c:set var="alignment_end" value="${fn:replace(start,',','') + 40}" /> </h4>

<form name="checkHandleForm" method="post" action="/dosomething.jsp" onsubmit="return false;">

    <imp:wdkTable tblName="HTSStrains" isOpen="true"/>

<table width="100%">
  <tr align=center>        
    <td><b>Please select at least two isolates strains to run Clustal Omega.</b></td>
  </tr>   
  <tr>
    <td align=center>

      <input type="button" value="Run Clustal Omega on Checked Strains" 
           onClick="goToIsolate(this,'htsSNP','${sequence_id}','${alignment_start}', '${alignment_end}')" />

      <input type="button" name="CheckAll" value="Check All" 
           onClick="wdk.api.checkboxAll(jQuery('input:checkbox[name=selectedFields]'))">
      <input type="button" name="UnCheckAll" value="Uncheck All" 
          onClick="wdk.api.checkboxNone(jQuery('input:checkbox[name=selectedFields]'))">
    </td>
  </tr> 
</table>
</form>

<c:if test = "${projectId == 'PlasmoDB'}">
  <imp:wdkTable tblName="Providers_other_SNPs" isOpen="true"/>
</c:if>


</c:otherwise>
</c:choose>

</imp:pageFrame>

<imp:pageLogger name="snp page" />
