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
    render json: { projects: projects, links: {} }, status: :ok # TODO links
  end

  def show
    project = Project.find_by_id(params[:id])
    if project
      external_project_link = ExternalProjectLink.where(project_id: project.id).first
      if external_project_link 
        external_project_link.accounts.each do |account|
          if(account.user == current_user)
            
            account.fetch_members(project)
            account.fetch_stories(project)
            project.reload
            render json: { id: project.id, title: project.title, team_members: project.team_members, stories: project.stories, links: {} }, status: :ok # TODO links 
            break
          end
        end
      else
        render json: {error: I18n.t('request.forbidden') }, status: :forbidden
      end
    else
      render json: {error: I18n.t('request.not_found') }, status: :not_found
    end
  end


  protected

  # def sync
  #   current_user.accounts.each { |account|
  #     account.sync
  #   }
  # end
end
