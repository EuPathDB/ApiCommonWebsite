
/*
we support two types of toggling, one compatible with Safari the other for the rest of the 
browsers. 

the version that works on Safari causes Netscape to lose focus on a click.

the version that works on Netscape doesn't work at all on Safari, as it seems the DOM tricks
in sayShowOrHide don't work

*/
var oldSiteUrl = "/";

$(document).ready(function() {
	popUnsupported();
});

function toggleLayer(controllingLayerName, textLayerName) {
    //alert("toggleLayer: " + controllingLayerName);
    var controllingLayer ; 
    if (document.getElementById) {    // this is the way the standards work
        controllingLayer = document.getElementById(controllingLayerName);
    } else if (document.all) {  // this is the way old msie versions work
        controllingLayer = document.all[controllingLayerName];
    } else if (document.layers) {   // this is the way nn4 works
       controllingLayer  = document.layers[controllingLayerName];
    }
    var style = controllingLayer.style;
    style.display = style.display? "":"block";   // toggle it
    sayShowOrHide(controllingLayerName, textLayerName, style);
    storeIntelligentCookie("show" + controllingLayerName, style.display == "block"? 1:0);
}

function sayShowOrHide(controllingLayerName, textLayerName, style) {
    var content = style.display == "block"? "Hide" : "Show";
    // don't use # shortcut for id lookup here...special characters
    // in element id cause problems, and for some reason escaping
    // with \\ (as spec'd in jquery docs) is not working.
    $("div[id='" + textLayerName + "'] a").text(content);
    return true;
}

function showLayer(whichLayer) {
    //alert("showLayer: " + whichLayer);
    if (document.getElementById) {
        // this is the way the standards work
           var style2 = document.getElementById(whichLayer).style;
           style2.display = "block";
    }
    else if (document.all) {
        // this is the way old msie versions work
        var style2 = document.all[whichLayer].style;
        style2.display = "block";
    } else if (document.layers) {
        // this is the way nn4 works
        var style2 = document.layers[whichLayer].style;
        style2.display = "block";
    }
    return true;
}

function hideLayer(whichLayer) {
    //alert("hideLayer: " + whichLayer);
    if (document.getElementById) {
        // this is the way the standards work
       	var style2 = document.getElementById(whichLayer).style;
        style2.display = "";
    }
    else if (document.all) {
        // this is the way old msie versions work
        var style2 = document.all[whichLayer].style;
        style2.display = "";
    } else if (document.layers) {
        // this is the way nn4 works
        var style2 = document.layers[whichLayer].style;
        style2.display = "";
    }
    return true;
}

function getCookie(name) {

    var start = document.cookie.indexOf(name + "=");

    if ( (!start) && name != document.cookie.substring(0,name.length) ) {
	return null;
    }

    if (start == -1) {
	return null;
    }

    var len = start + name.length + 1;
    var end = document.cookie.indexOf(";",len);
    if (end == -1) {
	end = document.cookie.length;
    }
	
    return unescape(document.cookie.substring(len,end));
}

function setCookie(name, value, expires, path, domain, secure) {
    // alert(name + "=" + escape(value) +
    //       ( (expires) ? ";expires=" + expires.toGMTString() : "") +
    //       ( (path) ? ";path=" + path : "") + 
    //       ( (domain) ? ";domain=" + domain : "") +
    //       ( (secure) ? ";secure" : ""));

    document.cookie = name + "=" + escape(value) +
        ( (expires) ? ";expires=" + expires.toGMTString() : "") +
        ( (path) ? ";path=" + path : "") + 
        ( (domain) ? ";domain=" + domain : "") +
        ( (secure) ? ";secure" : "");
}

function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
	document.cookie = name + "=" +
	    ( (path) ? ";path=" + path : "") +
	    ( (domain) ? ";domain=" + domain : "") +
	    ";expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

var today = new Date();
var zeroDate = new Date(0,0,0);
today.setTime(today.getTime() - zeroDate.getTime());

var todaysDate = new Date(today.getYear(),
			   today.getMonth(),
			   today.getDate(),
			   0, 0, 0);
var expiresDate = new Date(todaysDate.getTime() + (8 * 7 * 86400000));

function storeMasterCookie() {
    if (!getCookie('MasterCookie')) {
        setCookie('MasterCookie','MasterCookie');
    }
}

function storeIntelligentCookie(name, value, expires, path, domain, secure) {
    if (!getCookie('MasterCookie')) {
        storeMasterCookie();
    }
    var IntelligentCookie = getCookie(name);
    if ((!IntelligentCookie) || (IntelligentCookie != value)) {
        setCookie(name, value, expires, path, domain, secure);
        var IntelligentCookie = getCookie(name);
        if ((!IntelligentCookie) || (IntelligentCookie != value)) {
            deleteCookie('MasterCookie');
	}
    }
}

function uncheckFields(notFirst) {
    var form = document.downloadConfigForm;
    var cb = form.selectedFields;
    if (notFirst) {
        for (var i=1; i<cb.length; i++) {
            cb[i].checked = null;
        }
    } else {
        cb[0].checked = null;
    }
}

function checkFields(all) {
    var form = document.downloadConfigForm;
    var cb = form.selectedFields;
    cb[0].checked = (all > 0 ? null : 'checked');
    for (var i=1; i<cb.length; i++) {
        cb[i].checked = (all > 0 ? 'checked' : null);
    }
}

function chooseAll(bool, form, node) {
    if (form[node].type == 'select-multiple') {
      multiSelectAll(bool, form, node);
    } else {
      checkAll(bool, form, node);
    }
}

//function checkAll(bool, form, node) {
//    var cb = form[node];
//    cb[0].checked = (bool ? null : 'checked');
//    for (var i=0; i<cb.length; i++) {
//        cb[i].checked = (bool ? 'checked' : null);
//   }
//}

function checkAll(bool, form, node) {
    var cb = form[node];
    for (var i=0; i<cb.length; i++) {
	 if(bool && cb[i].checked == false) cb[i].click();
         if(!bool && cb[i].checked == true) cb[i].click();
    }
}

function multiSelectAll(bool, form, node) {
    var opt = form[node];
    opt[0].selected = (bool ? null : 'selected');
    for (var i=0; i<opt.length; i++) {
        opt[i].selected = (bool ? 'selected' : null);
    }
}



function handleHttpResponseImage(imgId, imgSrc) {
    var http = httpObjects[imgId];
    var msg = "in handleHttpResponseImage\n"
            + "http = " + http + "\n"
            + "state = " + http.readyState + "\n"
            + "imgId = " + imgId + "\n"
            + "imgSrc = " + imgSrc;

    // no need to wait till readyState == 4 'cuz we do not need responseText
    if (http.readyState == 1 || http.readyState == 0) {
        var img = document.getElementById(imgId);
        msg += "\nimg before='" + img + "'\n";
        if(img.src != null && img.src != imgSrc) {
            img.src = imgSrc;
        }
        msg += "\nsrc after='" + img.src + "'\n";
        workStates[imgId] = false;
    }
    //alert(msg);
}

function updateImage(imgId, imgSrc) {
    var http = getHTTPObject();
    httpObjects[imgId] = http;
    var isWorking = false;
    workStates[imgId] = isWorking;

    if (!isWorking && http) {
        //if imgSrc is on a different domain, we need to sign the scripts and ask for expanded privilege
        try {
            netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
        } catch (e) {
            //alert("cat not enable UniversalBrowserRead: " + e.message);
        }
        try {
            http.open("GET", imgSrc, true);
            http.onreadystatechange = handleHttpResponseImage(imgId, imgSrc);
            workStates[imgId] = true;
            http.send(null);
        } catch (e) {
            var img = document.getElementById(imgId);
            if(img.src != null && img.src != imgSrc) {
                img.src = imgSrc;
            }
        }
    }
    workStates[imgId] = false;
    return true;
}

function handle_dnaContextDiv() {
    handleHttpResponseImageMapDiv('dnaContextDiv');
}

function handle_proteinFeaturesDiv() { 
    handleHttpResponseImageMapDiv('proteinFeaturesDiv');
}

function handleHttpResponseImageMapDiv(imgMapDivId) {
    var http = httpObjects[imgMapDivId];
    if (http.readyState == 4) {
        var div = document.getElementById(imgMapDivId);
        if (document.getElementById(imgMapDivId).lastChild == null) {
            //document.getElementById(imgMapDivId).innerHTML = http.responseText;
            //TRICKY: this only works on Firefox/Netscape
            dynamiccontent(imgMapDivId, http.responseText);
        }
        workStates[imgMapDivId] = false;
    }
    //alert(imgMapDivId + ": state=" + http.readyState);
}

function dynamiccontent(elementid,content){
    if (document.getElementById && !document.all){
        rng = document.createRange();
        el = document.getElementById(elementid);
        rng.setStartBefore(el);
        htmlFrag = rng.createContextualFragment(content);
        while (el.hasChildNodes())
            el.removeChild(el.lastChild);
        el.appendChild(htmlFrag);
    }
}

function updateImageMapDiv(imgMapDivId, imgMapSrc, postLoadJS) {

    var http = getHTTPObject();
    httpObjects[imgMapDivId] = http;

    var slot = "#" + imgMapDivId;

    var isWorking = false;
    workStates[imgMapDivId] = isWorking;

    var loadingImg = ($("<div>").attr("id", "imgMapDivId_loading")).attr("class", "gbGnCtx").
          append($("<img/>").
            attr("src", "/assets/images/loading2.gif")).
          append("<br>Loading...");

    if (!isWorking && http) {
      $(slot).append(loadingImg);
      
      $(slot).load(imgMapSrc, null, 
              function(responseText, status, XMLHttpRequest) {
         $(postLoadJS.split(',')).each(function (i, val) {
            if (val.indexOf("wz_tooltip") != -1) {
              $("div[id^=tOoLtIp]").remove(); // previously loaded wz_tooltips
            }
            js = $("<script>").
                   attr("type", "text/javascript").
                   attr("src", val);
            $(slot).append(js);
         });
      });
       
      $().ajaxError(function(info,xhr){
        $(imgMapDivId).append("Oops: " +  xhr.status + ' ' + xhr.statusText);
      });
      
    }
    workStates[imgMapDivId] = false;
    return true;
}

function getHTTPObject() {
    var xmlhttp;
    /*@cc_on
    @if (@_jscript_version >= 5)
        try {
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (E) {
                xmlhttp = false;
            }
        }
    @else
        xmlhttp = false;
    @end @*/

    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
        try {
            xmlhttp = new XMLHttpRequest();
        } catch (e) {
            xmlhttp = false;
        }
    }
    return xmlhttp;
}

var httpObjects = new Object(); // a hash of XMLHttpObjects
var workStates = new Object();  // a hash of XMLHttpObjects working status


/* ==========================================================================
 * The following ajax methods are defined to fetch sub-pages
 * ========================================================================== */

function requestAsyncContent(url, contentTag) {
    // construct request
    var request;
    if (window.XMLHttpRequest) {    // firefox, mozilla, IE7
        request = new XMLHttpRequest();
    } else if (window.ActiveXObject) {    // IE6 or before
        request = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        return null;
    }
     
    request.open("GET", url, true);
    
    // construct callback wrapper
    function callbackWrapper() {
        if (request.readyState == 4) {
            receiveAsyncContent(request, contentTag);
        }
    }
    request.onreadystatechange = callbackWrapper;
    
    request.send(null);
}

function receiveAsyncContent(request, contentTag) {
    var content = document.getElementById(contentTag);
    if (request.status == 200) {    // success
        content.innerHTML = request.responseText;
    } else {    // http failure
        content.innerHTML = "Failed. Cannot retrieve the content.";
    }
}


// return domain.org from www.domain.org
function secondLevelDomain(){
  dm = document.domain.split(/\./);
  if(dm.length > 1) {
    return(dm[dm.length-2] + "." +  dm[dm.length-1]) ;
  }else{
    return("");
  }
}

function goToMySearches(){
	setCurrentTabCookie('search_history', false);
	return true;
}

/***************************************************
*  Charles Treatman 5/13/09
*  The following method is for the login form popup
*  and requires the jQuery BlockUI plugin.
***************************************************/

function popLogin(){
	$.blockUI({message : $("#loginForm"), css : {cursor: 'auto',width:'30%',top:'40%',left:'35%' }});
}

function popRegister(){
	$.blockUI({message : $("#registerForm"), css : {cursor: 'auto',width: '80%',top:'10%',left:'10%' } });
}

function popUnsupported(){
	if (!$.browser.mozilla && !$.browser.safari && !($.browser.msie && $.browser.version < 7) && $.cookie('api-unsupported') == null){
		var message = "<div id='browser-info'><h2>Your browser is not supported</h2><p>For the best experience using our website, we recommend that you download one of the supported browsers listed below.</p><h3>Download a Supported Browser:</h3><ul id='supported-browsers'><li class='browser-link'><a href='http://www.mozilla.com/firefox/'>Firefox</a></li><li class='browser-link'><a href='http://www.apple.com/safari/'>Safari</a></li><li class='browser-link win'><a href='http://www.microsoft.com/windows/internet-explorer/default.aspx'>Internet Explorer 8</a></li><li class='browser-link'><a href='http://www.microsoft.com/windows/internet-explorer/ie7/'>Internet Explorer 7</a></li><!--<li class='browser-link'><a href='http://www.opera.com/download/'>Opera</a></li>--></ul><p>If you are unable to install a supported browser, you may want to use the older version of this site, available <a href='" + oldSiteUrl + "'>here</a>.</p><p>If you would like to continue using this site without upgrading your browser, simply click 'Ignore' below.</p><input type='submit' value='Ignore' onclick=\"$.cookie('api-unsupported',true,{path:'/'});$.unblockUI();\"/></div>"
		$.blockUI({message : message, css : {cursor:'auto',top:'25%'}});
	}
}

function checkboxAll(field) {
  for (i = 0; i < field.length; i++)
    field[i].checked = true ;
}

function checkboxNone(field) {
  for (i = 0; i < field.length; i++)
    field[i].checked = false ;
}

