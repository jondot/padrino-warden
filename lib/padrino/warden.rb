require 'warden'

$:.unshift File.join( File.dirname(__FILE__), '..', '..' )

require 'padrino/warden/version'
require 'padrino/warden/controller'
require 'padrino/warden/helpers'

module Padrino
  module Warden
    def self.registered(app, register_controller = true)
      # Enable sessions but allow the user to disable them explicitly
      app.set :sessions, true unless app.respond_to?(:sessions)
      app.set :auth_failure_path, '/' unless app.respond_to?(:auth_failure_path)
      app.set :auth_success_path, '/' unless app.respond_to?(:auth_success_path)

      # set :auth_use_referrer to true to redirect a user back to an action
      # protected by 'login'/'authenticate' after successful login
      app.set :auth_use_referrer, false unless app.respond_to?(:auth_use_referrer)

      app.set :auth_error_message, "You have provided invalid credentials." unless app.respond_to?(:auth_error_message)
      app.set :auth_success_message, "You have logged in successfully." unless app.respond_to?(:auth_success_message)
      app.set :deauth_success_message, "You have logged out successfully." unless app.respond_to?(:deauth_success_message)
      # Custom map options and layout for the sessions controller
      app.set :auth_login_template, 'sessions/login' unless app.respond_to?(:auth_login_template)
      app.set :auth_login_path, 'sessions/login' unless app.respond_to?(:auth_login_path)
      app.set :auth_unauthenticated_path,'/unauthenticated' unless app.respond_to?(:auth_unauthenticated_path)
      app.set :auth_logout_path,'sessions/logout' unless app.respond_to?(:auth_logout_path)
      app.set :auth_login_layout, true unless app.respond_to?(:auth_login_layout)
      # OAuth Specific Settings
      app.set :auth_use_oauth, false unless app.respond_to?(:auth_use_oauth)
      app.set :default_strategies, [:password] unless app.respond_to?(:default_strategies)

      app.set :warden_failure_app, app unless app.respond_to?(:warden_failure_app)
      app.set :warden_default_scope, :session unless app.respond_to?(:warden_default_scope)
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
