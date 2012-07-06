require 'spec_helper'

describe TasksController do

  include ActionController::HttpAuthentication::Token

  describe "/tasks" do

    it "lists all the tasks for a project" do
      task = FactoryGirl.create(:task)
      task2 = FactoryGirl.create(:task, story: task.story)
      user = FactoryGirl.create(:external_project_link, project: task.story.project).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", project_id: task.story.project

      result = ActiveSupport::JSON.decode response.body
      result["tasks"].count.should eql 2
      result["tasks"].should =~ [task, task2].as_json
    end

    it "returns 404 when the project does not exist" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      get "list", project_id: 9999
      response.status.should eql 404
      result = ActiveSupport::JSON.decode response.body
      result["error"].should eql I18n.t("request.not_found")
    end

    it "denies access to projects that do not belong to the user" do
      unaccessable_task = FactoryGirl.create(:task)
      user = FactoryGirl.create :user
      FactoryGirl.create(:external_project_link, project: unaccessable_task.story.project)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      get "list", project_id: unaccessable_task.story.project.id
      result = ActiveSupport::JSON.decode response.body

      response.status.should == 403
      result["error"].should == I18n.t("request.forbidden")
    end
  end

  describe "/tasks/:id" do
    it "shows a task" do
      task  = FactoryGirl.create :task
      user = FactoryGirl.create(:external_project_link, project: task.story.project).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      get "show", id: task.id
      result = ActiveSupport::JSON.decode response.body
      result["task"].should == task.as_json
    end

    it "returns 404 when the task does not exist" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      get "show", id: 9999
      response.status.should == 404
      result = ActiveSupport::JSON.decode response.body
      result["error"].should == I18n.t("request.not_found")
    end

    it "denies access to tasks that the user does not have access to" do
      unaccessable_task = FactoryGirl.create :task
      FactoryGirl.create(:external_project_link, project: unaccessable_task.story.project)
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      get "show", id: unaccessable_task.id

      response.status.should == 403
      result = ActiveSupport::JSON.decode response.body
      result["error"].should == I18n.t("request.forbidden")
    end

    it "allows partial modifications of tasks to be made" do
      task = FactoryGirl.create :task
      user = FactoryGirl.create(:external_project_link).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      patch "modify", id: task.id, task: {status:"started"}

      result = ActiveSupport::JSON.decode response.body
      task.reload
      task.started?.should == true
      result["task"]["status"].should eql "started"
    end
  end

end
