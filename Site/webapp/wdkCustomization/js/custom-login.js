
function doCustomLogin(form, contextPath) {
  
  // get values user entered into the visible form
  var email = $(form).find("#email").val();
  var password = $(form).find("#password").val();
  //var openid = $(form).find("#openid").val();
  var remember = ($(form).find("#remember").prop('checked') ? "on" : "");
  var redirectUrl = $(form).find("#redirectUrl").val();
  // only pull redirectUrl from address bar if doesn't exist in form
  if (redirectUrl == "") {
    redirectUrl = window.location.href;
  }
  
  // close the login popup if present
  jQuery(form).closest('.ui-dialog-content').dialog('close');
  
  // create div to house iframe and append generated iframe element
  var iframe = document.createElement('iframe');
  jQuery(iframe).dialog({
      modal: true,
      closeOnEscape: false,
      open: function(event, ui) {
          jQuery(event.target).parent().find('.ui-dialog-titlebar-close').hide();
      },
      width: 'auto',
      title: 'Please Wait...'
  });

  //create a string to use as a new document object
  var frameContents = '' +
    '<html>' +
    '  <body style="background-color:white">' +
    '    <div style="margin-top:45px;text-align:center;font-family:sans-serif;font-size:1.2em">' +
    '      <strong>Checking Credentials...</strong>' +
    '      <form name="loginForm" method="post" action="' + contextPath + '/processLogin.do">' +
    '        <input type="hidden" name="email" value="' + email + '"/>' +
    '        <input type="hidden" name="password" value="' + password + '"/>' +
    //'        <input type="hidden" name="openid" value="' + openid + '"/>' +
    '        <input type="hidden" name="remember" value="' + remember + '"/>' +
    '        <input type="hidden" name="redirectUrl" value="' + redirectUrl + '"/>' +
    '      </form>' +
    '      <scr' + 'ipt type="text/javascript" src="' + contextPath + '/wdk/js/lib/jquery.js"></scr' + 'ipt>' +
    '      <scr' + 'ipt type="text/javascript"> jQuery(function() { jQuery("form").submit(); }); </scr' + 'ipt>' +
    '    </div>' +
    '  </body>' +
    '</html>';
  
  // get a handle on the <iframe>d document (in a cross-browser way)
  var doc = iframe.contentWindow || iframe.contentDocument;
  if (doc.document) {
    doc = doc.document;
  }

  // open, write content to, and close the document
  doc.open();
  doc.write(frameContents);
  doc.close();
  
  // return false so form does not submit
  return false;
}
