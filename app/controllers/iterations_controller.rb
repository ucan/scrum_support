class IterationsController < ApplicationController
  
  before_filter :authenticate

  # 1) List all iterations for a project
  # 2) Can be filtered by type - 'done' and 'backlog'
  def list
  	if params[:project_id]
  		epl = ExternalProjectLink.where(project_id: params[:project_id]).first
  		if epl
  			project = epl.project
  			authorized_account = authorized_account_for_project project
  			if authorized_account
  				authorized_account.fetch_iterations project
  				project.reload
          if !params[:type]
            params[:type] = "all"
          end
          show_iteration_type(project, params[:type])
  			else
  				render json: {error: I18n.t('request.forbidden') }, status: :forbidden
  			end
  		else
  			render json: {error: I18n.t('request.not_found') }, status: :not_found
  		end
  	else
  		render json: { error: "#{I18n.t('request.bad_request')}: project_id is required."}, status: :bad_request
  	end
  end

  # 1) Returns one of the users iterations (including a list of that iterations stories)
  # 2) TODO Can directly request the current iteration with query param[:type] = current
  def show
  	if params[:id]
      iteration = Iteration.where(id: params[:id]).first
      if iteration
        authorized_account = authorized_account_for_project iteration.project
        if authorized_account
          authorized_account.fetch_stories iteration
          iteration.reload
          json = iteration.as_json
          json["stories"] = iteration.stories
          render json: { iteration: json }, status: :ok
        else
          render json: {error: I18n.t('request.forbidden') }, status: :forbidden
        end
      else
        render json: {error: I18n.t('request.not_found') }, status: :not_found
      end
  	else
      render json: { error: "#{I18n.t('request.bad_request')}: id is required"}, status: :bad_request
    end
  end


  private

  def show_iteration_type(project, type)
  	if type == "all"
  		render json: { iterations: project.iterations }, status: :ok
  	elsif type == "backlog"
  		render json: { iterations: project.backlog }, status: :ok
  	elsif type == "done"
      render json: { iterations: project.done_iterations }, status: :ok
    else
  		error = "Invalid iteration type. Valid types are {current, backlog, all}"
  		render json: { error: "#{I18n.t('request.bad_request')}: #{error}"}, status: :bad_request
  	end
  end
end
