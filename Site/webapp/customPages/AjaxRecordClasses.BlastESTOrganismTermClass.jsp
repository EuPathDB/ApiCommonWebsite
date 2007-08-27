
<%@ 
    page contentType="text/xml"
%><%@
    taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" 
%><c:set 
    value="${requestScope.wdkRecord}" 
    var="wdkRecord"
/><c:set 
    var="tbl" value="${wdkRecord.tables['BlastESTOrganismTerms']}"
/><data><terms>
<c:forEach 
    var="row" items="${tbl.visibleRows}"
><term id="${row['internal'].value}">${row['term'].value}</term>
</c:forEach></terms></data>
<c:set var="junk" value="${tbl.close}"/>
