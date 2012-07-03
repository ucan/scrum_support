class TasksController < ApplicationController

  def list

    project = Project.find params[:project_id]
    result = []
    if project
      project.stories.each do |story|
        result.concat story.tasks
      end
    end

    render json: {tasks:result}
    
  end
end
