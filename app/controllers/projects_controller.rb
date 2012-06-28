class ProjectsController < ApplicationController

  before_filter :authenticate

  # Return a list of all projects (id, title) from all accounts
  def list
    user = user_from_auth_token
    projects = []
    user.accounts.each { |account|
      account.projects.each { |project| 
        projects << project
      }
    }
    render json: projects
  end 

  def show
    user = user_from_auth_token
    project = Project.find_by_id(params[:id])
    if !project.nil?
      if project.account.user == user
        render json: {people: project.people, stories: project.stories}
      else
        render json: {error: I18n.t('request.forbidden') }, status: :forbidden
      end
    else
      render json: {error: I18n.t('request.not_found') }, status: :not_found
    end
  end
end
