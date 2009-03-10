<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="project" value="${applicationScope.wdkModel.name}" />
<c:set var="xqSetMap" value="${wdkModel.xmlQuestionSetsMap}"/>
<c:set var="xqSet" value="${xqSetMap['XmlQuestions']}"/>
<c:set var="xqMap" value="${xqSet.questionsMap}"/>
<c:set var="newsQuestion" value="${xqMap['News']}"/>


<c:if test = "${project != 'GiardiaDB' && project != 'TrichDB' && project != 'ApiDB'}">

<c:set var="newsAnswer" value="${newsQuestion.fullAnswer}"/>
<c:set var="tutQuestion" value="${xqMap['Tutorials']}"/>
<c:set var="tutAnswer" value="${tutQuestion.fullAnswer}"/>
<c:set var="extlQuestion" value="${xqMap['ExternalLinks']}"/>
<c:set var="extlAnswer" value="${extlQuestion.fullAnswer}"/>
<c:set var="dateStringPattern" value="dd MMMM yyyy HH:mm"/>

</c:if>


<div id="leftcolumn">
  <div class="innertube">
    <div id="menu_lefttop">
        <img src="/assets/images/${project}/menu_lft1.png" alt="" width="208" height="12" />
        <a class="heading" id='news' href="#">News</a>


<%--------------  NEWS ---------------------------------------------%>


<c:if test = "${project != 'GiardiaDB' && project != TrichDB && project != ApiDB}">

   <div class="menu_lefttop_drop">
      <c:choose>
        <c:when test="${newsAnswer.resultSize < 1}">
          No news now, please check back later.<br>
        </c:when>
        <c:otherwise>
          <c:set var="i" value="1"/>
          <ul>
          <c:forEach items="${newsAnswer.recordInstances}" var="record">

          <c:if test="${i <= 4}">

            <c:set var="attrs" value="${record.attributesMap}"/>

            <c:set var='tmp' value="${attrs['tag']}"/>
            <c:set var='shorttag' value=''/>
            <c:forEach var="k" begin="0" end="${fn:length(tmp)}" step='3'>
               <c:set var='shorttag'>${shorttag}${fn:substring(tmp, k, k+1)}</c:set>
            </c:forEach>
            
            <fmt:parseDate pattern="${dateStringPattern}" 
                           var="pdate" value="${attrs['date']}"/> 
            <fmt:formatDate var="fdate" value="${pdate}" pattern="d MMMM yyyy"/>
      
            <li id="n-${shorttag}"><b>${fdate}</b>
                   <a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.News#newsItem${i}"/>">
                     ${attrs['headline']}
                   </a></li>
          </c:if>
          <c:set var="i" value="${i+1}"/>
          </c:forEach>
          <li style='list-style:circle;'>
            <a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.News"/>"
               class="blue">All ${project} News</a>
          </li>
          </ul>
        </c:otherwise>
      </c:choose>
   </div>

</c:if>

<%--------------  COMMUNITY LINKS ---------------------------------------------%>
    <img src="/assets/images/${project}/menu_lft1.png" alt="" width="208" height="12" />
    <a  class="heading" id='community' href="#">Community Resources</a>
    <div class="menu_lefttop_drop">
    Upcoming Events
    <site:communityEventListing/>
    
    <hr>
    Related Sites
    <c:choose>
      <c:when test="${extlAnswer.resultSize < 1}">
        No links.
      </c:when>
      <c:otherwise>
        <ul>
        <c:forEach items="${extlAnswer.recordInstances}" var="record">
          <c:forEach items="${record.tables}" var="table">
            <c:forEach items="${table.rows}" var="row"> 
               <c:set var='url' value='${row[1].value}'/>
               <c:set var='tmp' value='${fn:replace(url, "http://", "")}'/>
               <c:set var='tmp' value='${fn:replace(tmp, ".", "")}'/>
               <c:set var='uid' value=''/>
               <c:forEach var="i" begin="0" end="${fn:length(tmp)}" step='3'>
                  <c:set var='uid'>${uid}${fn:substring(tmp, i, i+1)}</c:set>
               </c:forEach>

               <li id='rs-${uid}'><a href="${url}">${row[0].value}</a></li>
            </c:forEach>
          </c:forEach>
        </c:forEach> 
        </ul>
      </c:otherwise>
    </c:choose>

    <br><a href="<c:url value="/help.jsp"/>" target="_blank" onClick="poptastic(this.href); return false;">
    <b>If you have a link that you think would be useful for the community, 
    please send us a note.</b></a>
    </div>



<%--------------  TUTORIALS ---------------------------------------------%>
        <img src="/assets/images/${project}/menu_lft1.png" alt="" width="208" height="12" />
        <a class="heading" id='tutorials' href="#">Web Tutorials</a>
        <div class="menu_lefttop_drop">

          <c:choose>
                      <c:when test="${tutAnswer.resultSize < 1}">
                        No tutorials.
                      </c:when>
                      <c:otherwise>
<c:if test="${project == 'TriTrypDB'}">
The TriTrypDB tutorials will be here soon. In the meantime we provide you with 
access to PlasmoDB.org and CryptoDB.org tutorials, websites that offer the same 
navigation and querying capabilities as in TriTrypDB.org.<br>
</c:if>
                        <ul>
                        <c:forEach items="${tutAnswer.recordInstances}" var="record">
         <c:set var="attrs" value="${record.attributesMap}"/>
         <c:forEach items="${record.tables}" var="table">
           <c:forEach items="${table.rows}" var="row">
             <c:set var="projects" value="${row[0].value}"/>
            <c:if test="${fn:containsIgnoreCase(projects, project)}"> 
            <li id='t-${attrs['uid']}'>${attrs['title']}<br /> 
                               (<a href="http://eupathdb.org/tutorials/${row[1].value}">Quick Time</a>)
                               (<a href="http://eupathdb.org/tutorials/${row[2].value}">Windows media</a>)
                               (<a href="http://eupathdb.org/tutorials/${row[3].value}">Flash</a>)
            </li>
            </c:if>
                                  </c:forEach> 
        </c:forEach>
      </c:forEach>
                        </ul>

                      </c:otherwise>
    </c:choose>

        </div>


<%--------------  INFO AND HELP ---------------------------------------------%>
        <img src="/assets/images/${project}/menu_lft1.png" alt="" width="208" height="12" />
        <a class="heading" id='informationAndHelp' href="#">Information and Help</a>
        <div class="menu_lefttop_drop">
        <ul id=information>
            <li id='h-3'><a href="<c:url value="/showXmlDataContent.do?name=XmlQuestions.Glossary"/>">Glossary of Terms</a></li>
            <li id='h-2'><a href="/awstats/awstats.pl?config=${fn:toLowerCase(project)}.org">Website Usage Statistics</a></li>
            <li id='h-1'><a href="<c:url value="/help.jsp"/>" target="_blank" onClick="poptastic(this.href); return false;">Contact Us</a></li>
        </ul></div>


    </div>
  </div>
</div>
  

<script type="text/javascript">
</script>
