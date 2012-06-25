class UserController < ApplicationController

	before_filter :authenticate, :only => :show

	# Create a new user
	def create
		user = User.new(name: params[:name])
		if user.save
			render :json => user
		else
			render :json => {:error => I18n.t('request.bad_request')}, :status => :bad_request
		end
	end

	# Return the authenticated user
	def show
		render :json => user_from_auth_token
	end
end