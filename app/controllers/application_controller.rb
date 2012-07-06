class ApplicationController < ActionController::API
  #protect_from_forgery
  #force_ssl
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Token

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(auth_token: token)
    end
    # authenticate_or_request_with_http_token do |token, options|
    #   apiKey = ApiKey.where(auth_token: token).first
    #   @current_user = apiKey.user if apiKey
  end

  def current_user
    api_key = ApiKey.where(auth_token: token_and_options(request)).first
    User.find(api_key.user_id) if api_key
  end
end
