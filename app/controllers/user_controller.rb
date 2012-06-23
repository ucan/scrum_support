class UserController < ApplicationController

	before_filter :authorised?, :only => :show

	def create
		@user = User.new(name: params[:name])
		@user.save
		render :json => @user
	end

	def show
		@user = user_from_auth_token
		render :json => @user
	end
end