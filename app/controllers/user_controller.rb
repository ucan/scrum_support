class UserController < ApplicationController

	before_filter :authenticate, :only => :show

	# Create a new user
	def create
		user = User.new(name: params[:name])
		user.save!
		render :json => user
	end

	# Return the authenticated user
	def show
		render :json => user_from_auth_token
	end
end