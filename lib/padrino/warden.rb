require 'warden'

$:.unshift File.join( File.dirname(__FILE__), '..', '..' )

require 'padrino/warden/version'
require 'padrino/warden/controller'
require 'padrino/warden/helpers'

module Padrino
  module Warden
    def self.registered(app, register_controller = true)
      {
        # Enable sessions but allow the user to disable them explicitly
        sessions: true,

        auth_failure_path: '/',
        auth_success_path: '/',

        # set :auth_use_referrer to true to redirect a user back to an action
        # protected by 'login'/'authenticate' after successful login
        auth_use_referrer: false,

        auth_protected_message: "Please log in.",
        auth_error_message:     "You have provided invalid credentials.",
        auth_success_message:   "You have logged in successfully.",
        deauth_success_message: "You have logged out successfully.",

        # Custom map options and layout for the sessions controller
        auth_login_path:     'sessions/login',
        auth_logout_path:    'sessions/logout',
        auth_login_template: 'sessions/login',
        auth_login_layout:   true,
        auth_unauthenticated_path: '/unauthenticated',

        # OAuth Specific Settings
        auth_use_oauth: false,
        default_strategies: [:password],

        warden_failure_app: app,
        warden_default_scope: :session,
      }.each do |setting, default|
        app.set setting, default unless app.respond_to? setting
      end

      app.set(:warden_config) { |manager| nil }
      app.use ::Warden::Manager do |manager|
        manager.scope_defaults :session, strategies: app.default_strategies
        manager.default_scope = app.warden_default_scope
        manager.failure_app   = app.warden_failure_app
        app.warden_config manager
      end

      if register_controller
        Controller.registered app
      end
      app.helpers Helpers
    end
  end
end
