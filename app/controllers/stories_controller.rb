class StoriesController < ApplicationController
	
	before_filter :authenticate

	def show
		user = current_user
		story = Story.find_by_id(params[:id])
    if !story.nil?
      if story.project.account.user == user
        render :json => story.tasks
      else
        render :json => {:error => I18n.t('request.forbidden') }, :status => :forbidden
      end
    else
      render :json => {:error => I18n.t('request.not_found')}, :status => :not_found
    end
	end
end
