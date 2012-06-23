class ApplicationController < ActionController::API
  #protect_from_forgery
  include ActionController::MimeResponds

  	def authorised?
		!User.find_by_authentication_token(params[:auth_token]).nil?
	end

	def user_from_auth_token
		User.find_by_authentication_token(params[:auth_token])
	end

end
