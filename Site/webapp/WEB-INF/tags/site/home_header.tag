<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>

<%@ attribute name="refer" 
 			  type="java.lang.String"
			  required="true" 
			  description="Page calling this tag"
%>

<c:set var="siteName" value="${applicationScope.wdkModel.name}" />

<html xmlns="http://www.w3.org/1999/xhtml">

<!--[if IE]>
<style type="text/css" media="screen">
body {
behavior: url(/assets/css/csshover.htc);
font-size: 100%;
}

#menu ul li {float: left; width: 100%;}
#menu ul li a {height: 1%;} 

#menu a, #menu h2 {
font: bold 0.7em/1.4em arial, helvetica, sans-serif;
}
</style>
<![endif]-->

<!--[if IE]>
<style type="text/css"> 
.twoColHybLt #sidebar1 { padding-top: 30px; }
.twoColHybLt #mainContent { zoom: 1; padding-top: 15px; }
</style>
<![endif]-->


<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CryptoDB -- Cryptosporidium Genome Resources</title>
<link href="/assets/css/crypto.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/assets/css/history.css" type="text/css"/>
<link rel="stylesheet" type="text/css" href="/assets/css/Strategy.css" />
<link rel="StyleSheet" href="/assets/css/filter_menu.css" type="text/css"/>

<style type="text/css">
<!--
body {
	background-image: url(/assets/images/crypto/background_s.jpg);
	background-repeat: repeat-x;
    }
body {
behavior: url(/assets/css/csshover.htc);
}
#header {
	height: 104px;
	background-image: url(/assets/images/crypto/backgroundtop_s.jpg);
}
#header p {
	font-size: 9px;
}
-->
</style>

<site:jscript refer="${refer}"/>
</head>

<body>

<div id="header2">
   <div id="header_rt">
   <div align="right"><div id="toplink"><a href="http://eupathdb.org"><img src="../assets/images/crypto/partofeupath.png" alt="EuPathDB Homepage" 
	width="174" height="23" /></a></div></div>
       <div id="bottom">
	  <site:quickSearch /><br />
	  <div id="nav_topdiv">
      <ul id="nav_top">
      <li>
      <a href="#">About ${siteName}<img src="../assets/images/crypto/menu_divider5.png" width="17" height="9" /></a>
      		<ul>
          <li><a href="#">Who We Are</a></li>
          <li><a href="#">What We Do</a></li>
          <li><a href="#">What You Can Do Here</a></li>
          <li><a href="#">News</a></li>
          <li><a href="#">Acknowledgements</a></li>
        	</ul>
        </li>
      <li>
      <a href="#">Help<img src="../assets/images/crypto/menu_divider5.png" width="17" height="9" /></a>
      		<ul>
          <li><a href="#">Web Tutorials</a></li>
          <li><a href="#">Community Links</a></li>
          <li><a href="#">Glossary of Terms</a></li>
          <li><a href="#">Website Statistics</a></li>
        	</ul>
        </li>
      <li>
      <a href="#">Contact Us<img src="../assets/images/crypto/menu_divider5.png" width="17" height="9" /></a></li>
      <li>
      <a href="#">Log In/Register</a> <%-- possible style when a user is login....<a href="#">Logout</a>
 	  <br /><b style='color:black'>John Doe</b> | <a href="#">Profile</a>
	  --%></li>      
      </ul>
      </div>
      	  
       </div>
   </div>

   <p><a href="/"><img src="../assets/images/crypto/title_s.png" alt="CryptoDB" 
	width="318" height="64" align="left" /></a></p>
   <p>&nbsp;</p>
   <p>Version 3.8<br />
   October 15, 2008</p>
</div> 
