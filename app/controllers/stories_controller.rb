class StoriesController < ApplicationController
	
	before_filter :authenticate

	def show
		user = user_from_auth_token
		story = Story.find_by_id(params[:id])
    if !story.nil?
      projectMapping = ProjectMapping.where(project_id: story.project.id).first
      if projectMapping && projectMapping.account.user == user
        projectMapping.account.fetch_tasks(story)
        story.reload
        render json: { tasks: story.tasks, links: {} }, status: :ok # TODO links
      else
        render json: { error: I18n.t('request.forbidden') }, status: :forbidden
      end
    else
      render json: { error: I18n.t('request.not_found')}, status: :not_found
    end
	end
end
