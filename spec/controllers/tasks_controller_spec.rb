require 'spec_helper'

describe TasksController do
  describe "/tasks" do
    
    it "lists all the tasks for a project" do
     task = FactoryGirl.create(:task)
     task2 = FactoryGirl.create(:task, story: task.story)

     get "list", project_id: task.story.project

     result = ActiveSupport::JSON.decode response.body
     result["tasks"].count.should eql 2
     result["tasks"].should =~ [task, task2].as_json
    end
  end

end
