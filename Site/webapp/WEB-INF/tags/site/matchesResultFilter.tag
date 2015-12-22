<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<%@ attribute name="summary"
              type="org.gusdb.wdk.model.filter.FilterSummary"
              required="true"
              description="Filter summary value."
%>
<%@ attribute name="step"
              type="org.gusdb.wdk.model.jspwrap.StepBean"
              required="true"
              description="Step being filtered."
%>
  
<!-- transcript counts -->
<c:set var="Y" value="${summary.counts['Y']}"/> <!-- empty string when 0 -->
<c:set var="N" value="${summary.counts['N']}"/>

<c:set var="option" value="${step.filterOptions.filterOptions['matched_transcript_filter_array']}"/>
<c:set var="values" value="${option.value}"/>
<%-- ${values}  contains default checkboxes or what was stored in the step, eg: {"values":["Y"]} 
--%>

<c:set var="Ychecked" value="${fn:contains(values,'Y') ? 'checked' : 'unchecked'}" />
<c:set var="Nchecked" value="${fn:contains(values,'N') ? 'checked' : 'unchecked'}" />
<c:set var="Ydisabled" value="${Y eq null ? 'disabled' : ''}" />
<c:set var="Ndisabled" value="${N eq null ? 'disabled' : ''}" />


<!-- HORIZONTAL LAYOUT

<table id="leafFilter" data-display="${N ne null}" data-Y="${Y}" data-N="${N}"> 
  <tr>
    <td id="prompt" class="acenter"><br>Include Transcripts returned by: </td>
  </tr>
  <tr>
    <td>
    <table>
    <tr>
      <td class="${Y eq null ? 'muted' : ''}"><input name="values" type="checkbox" value="Y" ${Ydisabled} ${Ychecked} amount="${Y eq null ? 0 : Y}"/> matched</td>
      <td class="${N eq null ? 'muted' : ''}"><input name="values" type="checkbox" value="N" ${Ndisabled} ${Nchecked} amount="${N eq null ? 0 : N}"/> did not match</td>
    </tr>
    <tr>
      <td class="center ${Y eq null ? 'muted' : ''}"><b>${Y eq null ? 0 : Y}</b> transcripts</td>
      <td class="center ${N eq null ? 'muted' : ''}"><b>${N eq null ? 0 : N}</b> transcripts</td>
    </tr>
    </table>
    </td>
  </tr>
</table>

-->


<!-- VERTICAL layout -->

<table id="leafFilter" data-display="${N ne null}" data-Y="${Y}" data-N="${N}" >
<tr>
  <td id="prompt">Include Transcripts returned by: </td>
  <td>
    <table>
    <tr>
      <td><input name="values" type="checkbox" value="Y" ${Ydisabled} ${Ychecked} amount="${Y eq null ? 0 : Y}"/></td>
      <td class="${Y eq null ? 'muted' : ''} aleft">matched</td>
      <td class="${Y eq null ? 'muted' : ''} aright"><b>${Y eq null ? 0 : Y}</b> transcripts</td>
    </tr>
    <tr>
      <td><input name="values" type="checkbox" value="N" ${Ndisabled} ${Nchecked} amount="${N eq null ? 0 : N}"/></td>
      <td class="${N eq null ? 'muted' : ''} aleft">did not match</td>
      <td class="${N eq null ? 'muted' : ''} aright"><b>${N eq null ? 0 : N}</b> transcripts</td>
    </tr>
    </table>
  </td>
</tr>
</table>

