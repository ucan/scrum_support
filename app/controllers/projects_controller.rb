class ProjectsController < ApplicationController

  before_filter :authenticate

  # Return a list of all project ids (from all accounts)
  def list
    user = current_user
    projects = []
    user.accounts.each { |account|
      account.projects.each { |project| 
        projects << project
      }
    }
    render :json => projects
  end

  # Return a list of stories for a project
  def show
    user = current_user
    project = Project.find_by_id(params[:id])
    if !project.nil?
      if project.account.user == user
        render :json => project.stories
      else
        render :json => {:error => I18n.t('request.forbidden') }, :status => :forbidden
      end
    else
      render :json => {:error => I18n.t('request.not_found')}, :status => :not_found
    end
  end
end
