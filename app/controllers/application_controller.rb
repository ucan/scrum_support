class ApplicationController < ActionController::API
  #protect_from_forgery
  #force_ssl
  
  include ActionController::MimeResponds

  	def authenticate
		if params[:auth_token].nil? || User.find_by_authentication_token(params[:auth_token]).nil?
			render :json => {:error => I18n.t('request.unauthorized') }, :status => :unauthorized
		end
	end

	def user_from_auth_token
		User.find_by_authentication_token(params[:auth_token]) if !params[:auth_token].nil?
	end
end
