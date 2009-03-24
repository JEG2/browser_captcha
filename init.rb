require "browser_captcha/use_browser_captcha"
require "browser_captcha/param_fields"

ActionController::Base.send :include, BrowserCaptcha::UseBrowserCaptcha
ActionView::Base.send       :include, BrowserCaptcha::ParamFields
