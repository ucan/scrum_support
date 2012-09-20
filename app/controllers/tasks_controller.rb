class TasksController < ApplicationController

  before_filter :authenticate

  # Returns a list of all tasks for a story
  def list
    if params[:story_id]
      story = Story.where(id: params[:story_id]).first
      if story
        authorized_account = authorized_account_for_project story.iteration.project
        if authorized_account
          authorized_account.fetch_tasks story
          story.reload
          render json: {tasks: story.tasks}
        else
          render json: {error: I18n.t("request.forbidden")}, status: :forbidden
        end
      else
        render json: {error: I18n.t("request.not_found")}, status: :not_found
      end
    else
      render json: {error: "#{I18n.t('request.bad_request')}: story_id is required."}, status: :bad_request
    end
  end

  # Returns one task
  def show
    task = Task.find_by_id params[:id]
    if task
      authorized_account = authorized_account_for_project task.story.iteration.project
      if authorized_account
        render json: {task: task }
      else
        render json: {error: I18n.t("request.forbidden")}, status: :forbidden
      end
    else
      render json: {error: I18n.t("request.not_found")}, status: :not_found
    end

  end

  def modify
    # TODO Update PT
    task = Task.find_by_id params[:id]
    #task.assign_attributes params[:task]
    if task
      authorized_account = authorized_account_for_project task.story.iteration.project
      if authorized_account
        if params[:status]
          task.status = params[:status]
        end
        if task.valid?
         # account = authorized_account_for_project task.story.iteration.project
          task.owner = authorized_account.team_member
          task.save!
          render json: {task: task}
        else
          render json: {error: "#{I18n.t('request.bad_request')}: #{task.errors.full_messages}"}, status: :bad_request
        end
      else
        render json: {error: I18n.t("request.forbidden")}, status: :forbidden
      end
    else
      render json: {error: I18n.t("request.not_found")}, status: :not_found
    end
  end

end
