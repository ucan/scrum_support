class StoriesController < ApplicationController
	
	before_filter :authenticate

	def show
		user = user_from_auth_token
		story = Story.find(params[:id])
		if story.project.account.user == user
			render :json => story.tasks
		else
			render :json => {:error => I18n.t('request.forbidden') }, :status => :forbidden
		end
	end
end
