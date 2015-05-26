<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set value="${wdkRecord.primaryKey.values}" var="vals"/>
<c:set value="${vals['source_id']}" var="id"/>
<c:set value="${vals['project_id']}" var="pid"/>
<c:set var="type" value="${wdkRecord.recordClass.fullName}" />
<c:set var="recordType" value="${wdkRecord.recordClass.displayName}" />
<div id="record-toolbox">
  <ul>
    <c:choose>
      <c:when test="${type == 'GeneRecordClasses.GeneRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=GeneQuestions.GeneBySingleLocusTag&skip_to_download=1&value(single_gene_id)=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'EstRecordClasses.EstRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=EstQuestions.EstBySourceId&skip_to_download=1&est_id_type=data&est_id_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'IsolateRecordClasses.IsolateRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=IsolateQuestions.IsolateByIsolateId&skip_to_download=1&isolate_id_type=data&isolate_id_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'SequenceRecordClasses.SequenceRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=GenomicSequenceQuestions.SequenceBySourceId&skip_to_download=1&sequenceId_type=data&sequenceId_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'SnpRecordClasses.SnpRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=SnpQuestions.NgsSnpBySourceId&skip_to_download=1&ngs_snp_id_type=data&ngs_snp_id_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'SnpChipRecordClasses.SnpChipRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=SnpChipQuestions.SnpBySourceId&skip_to_download=1&snp_id_type=data&snp_id_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
      <c:when test="${type == 'OrfRecordClasses.OrfRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=OrfQuestions.OrfByOrfId&skip_to_download=1&orf_id_type=data&orf_id_data=${id}" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
 <c:when test="${type == 'DynSpanRecordClasses.DynSpanRecordClass'}">
        <li>
          <c:url var="downloadUrl" value="/showSummary.do?questionFullName=SpanQuestions.DynSpansBySourceId&skip_to_download=1&span_id_type=data&span_id_data=${id}&array(organism)=Plasmodium berghei ANKA&array(chromosomeOptional)=Choose chromosome&value(start_point)=1&value(end_point_segment)=100&array(sequence_strand)=f" />
          <a class="download" href="${downloadUrl}" title="Download this ${recordType}">Download</a>
        </li>
      </c:when>
    </c:choose>
    <li>
        <a class="show-all" href="" title="Show all sections">Show All</a>
    </li>
    <li>
        <a class="hide-all" href="" title="Hide all sections">Hide All</a>
    </li>
  </ul>
</div>

<script>
  (function() {
    (new eupathdb.TableToggler).initialize();
  })();
</script>
