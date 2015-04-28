module Padrino
  module Warden
    module Controller
      def self.registered(app)
        app.controller :sessions do
          %w(get put post delete head options patch link unlink).each do |method|
            __send__ method, :unauthenticated, map: app.auth_unauthenticated_path do
              status 401
              warden.custom_failure! if warden.config.failure_app == self.class
              flash.now[:error] = settings.auth_error_message if flash
              render settings.auth_login_template , layout: settings.auth_login_layout
            end
          end
          ## /sessions/login
          get :login , map: app.auth_login_path  do
            session.delete(:return_to)
            if settings.auth_use_oauth && !@auth_oauth_request_token.nil?
              session[:request_token] = @auth_oauth_request_token.token
              session[:request_token_secret] = @auth_oauth_request_token.secret
              redirect @auth_oauth_request_token.authorize_url
            else
              render settings.auth_login_template , layout: settings.auth_login_layout
            end
          end

          post :login , map: app.auth_login_path do
            authenticate
            flash[:success] = settings.auth_success_message if flash
            redirect settings.auth_use_referrer && session[:return_to] ? session.delete(:return_to) :
              settings.auth_success_path
          end

          get :logout ,map: app.auth_logout_path do
            logout
            flash[:success] = settings.deauth_success_message if flash
            redirect settings.auth_success_path
          end

          get :oauth_callback do
            if settings.auth_use_oauth
              authenticate
              flash[:success] = settings.auth_success_message if flash
              redirect settings.auth_success_path
            else
              redirect settings.auth_failure_path
            end
          end
        end
      end
    end
  end
end
