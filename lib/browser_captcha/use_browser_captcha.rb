module BrowserCaptcha
  SECRET = "REPLACE_ME!!!"
  
  module UseBrowserCaptcha
    module ClassMethods
      def use_browser_captcha(*args)
        prepend_before_filter :check_captcha_cookie, *args
      end
    end

    module InstanceMethods
      private
      
      def check_captcha_cookie
        render_browser_captcha unless cookies[BrowserCaptcha::SECRET]
      end

      def render_browser_captcha
        render :inline => <<-END_BROWSER_CAPTCHA.strip
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
                              "http://www.w3.org/TR/html4/strict.dtd">
        <html lang="en">
          <head>
          	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
          	<title>Browser Captcha</title>
          	<script type="text/javascript" charset="utf-8">
            	function createCookie(name,value) {
            		document.cookie = name + "=" + value + "; path=/";
            	}
            	function readCookie(name) {
            		var nameEQ = name + "=";
            		var ca = document.cookie.split(';');
            		for(var i=0;i < ca.length;i++) {
            			var c = ca[i];
            			while (c.charAt(0)==' ') c = c.substring(1,c.length);
            			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
            		}
            		return null;
            	}
            	function main() {
            		if(readCookie('<%= BrowserCaptcha::SECRET %>') == null) {
            			var form = document.getElementById('resubmit_the_form');
            			createCookie('<%= BrowserCaptcha::SECRET %>', 1);
            			form.submit();
            		}
            	}
          	</script>
          </head>
          <body onload="main();">
            <p>
              Give me just a moment to bug your browser and force it to prove
              you are not a spammer…
            </p>
            <form id="resubmit_the_form" method="POST" accept-encoding="UTF-8" action="<%= request.request_uri %>">
              <%= param_fields %>
            </form>
            <noscript>
              Please go back, enable JavaScript, and then re-submit the form.
            </noscript>
          </body>
        </html>
        END_BROWSER_CAPTCHA
      end
    end

    def self.included(receiver)
      receiver.extend           ClassMethods
      receiver.send   :include, InstanceMethods
    end
  end
end
