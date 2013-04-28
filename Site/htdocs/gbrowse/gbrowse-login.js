
jQuery(function(){
    GB.performLogin();
});

var GB = {
    
    WDK_COOKIE_NAME : "wdk_check_auth",
    
    performLogin : function() {
        // render the progress bar
        GB.updateProgress(0, 0);
    
        // try to split cookie into email and checksum
        var creds = GB.splitAuthCookie(jQuery.cookies.get(GB.WDK_COOKIE_NAME));

        if (creds == undefined) {
            alert("System error: the WDK login cookie cannot be found; unable to complete GBrowse login.");
        }
        else {
            // update progress bar and add some more in a bit (while ajaxing)
            GB.updateProgress(30, 0);
            GB.updateProgress(45, 450);

            // retrieve project name (where gbrowse resides), and redirect url from this page's URL
            var project = GB.getParameterByName('project');
            var redirectUrl = GB.getParameterByName('redirectUrl');
          
            // append login form to the bottom of the page (is display:none)
            var html = GB.getLoginFormHtml(project, creds);
            jQuery('body').append(html);
          
            // run authentication
            Controller.plugin_authenticate($('plugin_configure_form'),
            $('login_message'),'/cgi-bin/gbrowse/'+project,redirectUrl);
        }
    },
  
    updateProgress : function(amountPct, delayMs) {
        if (delayMs == 0) {
            jQuery('#progressbar').progressbar({ value: amountPct });
        } else {
            setTimeout(function() { GB.updateProgress(amountPct, 0); }, delayMs);
        }
    },

    getLoginFormHtml : function(project, creds) {
        return '' +
            '<div style="display:none">' +
            '  <div id="login_message"></div>' +
            '  <form method="post" action="/cgi-bin/gbrowse/'+project+'/?action=plugin_login"' +
            '        name="configure_plugin" id="plugin_configure_form">' +
            '    <input type="hidden" name="plugin" value="Authorizer Template"/>' +
            '    <input type="text" name="WdkSessionAuthenticator.name" value="' + creds.email + '"/>' +
            '    <input type="text" name="WdkSessionAuthenticator.password" value="' + creds.checksum + '"/>' +
            '    <input type="text" id="authenticate_remember_me" value=""/>' +
            '  </form>' +
            '</div>';
    },

    getParameterByName : function(name) {
        var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
        return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
    },
  
    splitAuthCookie : function(cookieVal) {
        if (cookieVal == null) {
            return undefined;
        }
        // find index of last '-'
        var lastIndex = -1, index = cookieVal.indexOf("-");
        while (index > -1) {
            lastIndex = index;
            index = cookieVal.indexOf("-", index + 1);
        }
        if (lastIndex == -1) {
            return undefined;
        }
        return {
            "email" : cookieVal.substring(0, lastIndex),
            "checksum" : cookieVal.substring(lastIndex + 1)
        };
    }
};
