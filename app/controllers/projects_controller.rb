class ProjectsController < ApplicationController

  before_filter :authenticate

  # Return a list of all projects (id, title) from all accounts
  def list
    projects = []
    current_user.accounts.each { |account|
      account.fetch_projects
      account.reload
      account.projects.each { |project|
        projects << project
      }
    }
    render json: { projects: projects }, status: :ok
  end

  def show
    project = Project.find_by_id(params[:id])
    if project
      external_project_link = ExternalProjectLink.where(project_id: project.id).first
      if external_project_link
        account = external_project_link.accounts.detect { |acc| acc.user == current_user }
        if account
          account.fetch_members(project)
          account.fetch_stories(project)
          project.reload 
          render json: { id: project.id, title: project.title, team_members: project.team_members.as_json(project_id: project.id), stories: project.stories }, status: :ok
        else
          render json: {error: I18n.t('request.forbidden') }, status: :forbidden
        end
      else 
        # It is not an external project...therefore it cannot exist...arrghhhh!!!
        render json: {error: I18n.t('request.not_found') }, status: :not_found
      end
    else
      render json: {error: I18n.t('request.not_found') }, status: :not_found
    end
  end
end
