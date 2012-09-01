class TasksController < ApplicationController

  before_filter :authenticate

  def list
    project = Project.find_by_id params[:project_id]
    result = []
    if project
      authorized_account = authorized_account_for_project project
      if authorized_account
        project.stories.each do |story|
          result.concat story.tasks
        end
        render json: {tasks: result}
      else
        render json: {error: I18n.t("request.forbidden")}, status: :forbidden
      end
    else
      render json: {error: I18n.t("request.not_found")}, status: :not_found
    end
  end

  def show
    task = Task.find_by_id params[:id]
    if task
      authorized_account = authorized_account_for_project task.story.project
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
      authorized_account = authorized_account_for_project task.story.project
      if authorized_account
        if params[:status]
          task.status = params[:status]
        end
        if task.valid?
          account = authorized_account_for_project task.story.project
          task.owner = account.team_member
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
  
  private

  def authorized_account_for_project(project)
    authorized_account = nil
    authorized_accounts = ExternalProjectLink.where(project_id: project.id).first.accounts
    current_user.accounts.each do |account|
      if authorized_accounts.include? account
        authorized_account = account
        break
      end
    end
    authorized_account
  end

end
