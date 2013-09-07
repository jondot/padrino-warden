require 'warden'
require File.join(File.dirname(__FILE__), 'padrino', 'warden')

Warden::Manager.before_failure do |env, opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  env['REQUEST_METHOD'] = "POST"

  # Make sure our modified request isn't stopped by
  # Rack::Protection::AuthenticityToken, if user doesn't have csrf set yet
  request = Rack::Request.new(env)
  csrf = request.session[:csrf] || SecureRandom.hex(32)
  env['HTTP_X_CSRF_TOKEN'] = request.session[:csrf] = csrf
end
