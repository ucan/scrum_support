class StoriesController < ApplicationController

  before_filter :authenticate

  def show
    story = Story.find_by_id(params[:id])
    if !story.nil?
      external_project_link = ExternalProjectLink.where(project_id: story.project.id).first
      if external_project_link
        external_project_link.accounts.each do |account|
          if account.user == current_user
            account.fetch_tasks(story)
            story.reload
            render json: { tasks: story.tasks }, status: :ok
            break
          end
        end
      else
        render json: { error: I18n.t('request.forbidden') }, status: :forbidden
      end
    else
      render json: { error: I18n.t('request.not_found')}, status: :not_found
    end
  end
end
