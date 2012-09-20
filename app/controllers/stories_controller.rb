class StoriesController < ApplicationController

  before_filter :authenticate

  # Returns a list of all stories (basic details) for an iteration
  def list
    if params[:iteration_id]
      iteration = Iteration.where(id: params[:iteration_id]).first
      if iteration
        authorized_account = authorized_account_for_project iteration.project
        if authorized_account
          authorized_account.fetch_stories iteration
          iteration.reload
          render json: { stories: iteration.stories }, status: :ok
        else
          render json: { error: I18n.t('request.forbidden') }, status: :forbidden
        end
      else
        render json: { error: I18n.t('request.not_found')}, status: :not_found
      end
    else
      render json: { error: "#{I18n.t('request.bad_request')}: iteration_id is required."}, status: :bad_request
    end
  end

  # Returns one of the users stories (including all of its tasks)
  def show
    story = Story.where(id: params[:id]).first
    if story
      external_project_link = ExternalProjectLink.where(project_id: story.iteration.project.id).first
      if external_project_link
        account = authorized_account_for_project story.iteration.project
        account.fetch_tasks story
        story.reload
        json = story.as_json
        json["tasks"] = story.tasks
        render json: { story: json }, status: :ok
      else
        render json: { error: I18n.t('request.forbidden') }, status: :forbidden
      end
    else
      render json: { error: I18n.t('request.not_found')}, status: :not_found
    end
  end
end
