class ApplicationController < ActionController::API
  #protect_from_forgery
  #force_ssl

  def authenticate
    if params[:auth_token].nil? || User.where(authentication_token: params[:auth_token]).first.nil?
      render json: {error: I18n.t('request.unauthorized') }, status: :unauthorized
    end
  end

  def user_from_auth_token
    User.where(authentication_token: params[:auth_token]).first if !params[:auth_token].nil?
  end
  
end
