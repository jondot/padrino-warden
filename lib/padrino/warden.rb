require 'warden'

$:.unshift File.join( File.dirname(__FILE__), '..', '..' )

require 'padrino/warden/version'
require 'padrino/warden/controller'
require 'padrino/warden/helpers'

module Padrino
  module Warden
    def self.registered(app)
      # Enable Sessions
      app.set :sessions, true
      app.set :auth_failure_path, '/'
      app.set :auth_success_path, '/'

      # Setting this to true will store last request URL
      # into a user's session so that to redirect back to it
      # upon successful authentication
      app.set :auth_use_referrer,      false
      app.set :auth_error_message,     "You have provided invalid credentials."
      app.set :auth_success_message,   "You have logged in successfully."
      app.set :deauth_success_message, "You have logged out successfully."
      app.set :auth_login_template,    'sessions/login'

      # OAuth Specific Settings
      app.set :auth_use_oauth, false

      app.set :warden_failure_app, app
      app.set :warden_default_scope, :session
      app.set(:warden_config) { |manager| nil }

      app.use ::Warden::Manager do |manager|
        manager.scope_defaults :session, strategies: [:password]
        manager.default_scope = app.warden_default_scope
        manager.failure_app   = app.warden_failure_app
        app.warden_config manager
      end

      Controller.registered app
      app.helpers Helpers
    end
  end
end
