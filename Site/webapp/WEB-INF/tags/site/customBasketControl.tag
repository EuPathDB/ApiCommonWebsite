<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- get the current record class --%>
<c:set var="projectId" value="${applicationScope.wdkModel.projectId}" />


<%-- export basket --%>
<%-- enable basket exporting for build-14 --%>

<%-- NOT FOR BUILD14
<div id="export-basket">
  Export basket to:
  <select id="to-project">
    <c:choose>
      <c:when test="${projectId == 'EuPathDB'}">
        <option value="AmoebaDB" selected="selected">AmoebaDB</option>
        <option value="CryptoDB">CryptoDB</option>
        <option value="GiardiaDB">GiardiaDB</option>
        <option value="MicrosporidiaDB">MicrosporidiaDB</option>
        <option value="PlasmoDB">PlasmoDB</option>
        <option value="ToxoDB">ToxoDB</option>
        <option value="TrichDB">TrichDB</option>
        <option value="TriTrypDB">TriTrypDB</option>
      </c:when>
      <c:otherwise>
        <option value="EuPathDB" selected="selected">EuPathDB</option>
      </c:otherwise>
    </c:choose>
  </select>
  <input type="button" value="Export" onclick="exportBasket()" />
</div>
--%>
