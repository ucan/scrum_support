class ProjectsController < ApplicationController

  before_filter :authenticate

  # Return a list of all projects (id, title, current_iteration_id) from all of the users accounts
  def list
    projects = []
    current_user.accounts.each { |account|
      account.fetch_projects
      account.reload
      projects.concat account.projects
    }
    render json: { projects: projects }, status: :ok
  end

  # Return one of the users projects (including all team_members and iterations for that project)
  def show
    project = Project.find_by_id(params[:id])
    if project
      external_project_link = ExternalProjectLink.where(project_id: project.id).first
      if external_project_link
        account = authorized_account_for_project project
        if account
          account.fetch_members project
          account.fetch_iterations project
          project.reload
          json = project.as_json
          json["team_members"] = project.team_members.as_json(project_id: project.id)
          json["iterations"] = project.iterations
          render json: { project: json }, status: :ok
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
