require 'spec_helper'

describe TasksController do

  include ActionController::HttpAuthentication::Token

  describe "list" do
    it "returns all the tasks for a story" do
      task1 = FactoryGirl.create(:task)
      task2 = FactoryGirl.create(:task, story: task1.story)
      user = FactoryGirl.create(:external_project_link, project: task1.story.iteration.project).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", story_id: task1.story.id

      result = ActiveSupport::JSON.decode response.body
      result["tasks"].count.should eql 2
      result["tasks"].should =~ [task1, task2].as_json
    end

    it "returns 404:not_found when the story does not exist" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      get "list", story_id: 9999
      response.status.should eql 404
      result = ActiveSupport::JSON.decode response.body
      result["error"].should eql I18n.t("request.not_found")
    end

    it "denies access to tasks for stories that the user is not authorized to view" do
      unaccessable_task = FactoryGirl.create(:task)
      user = FactoryGirl.create :user
      FactoryGirl.create(:external_project_link, project: unaccessable_task.story.iteration.project)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      get "list", story_id: unaccessable_task.story.id
      result = ActiveSupport::JSON.decode response.body

      response.status.should == 403
      result["error"].should == I18n.t("request.forbidden")
    end

    it "provides feedback on bad requests" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      get "list" # Needs a story_id query parameter to be a valid request
      result = ActiveSupport::JSON.decode response.body
      response.status.should == 400
      result["error"].should == "#{I18n.t('request.bad_request')}: story_id is required."
    end
  end

  describe "show" do
    it "returns a task with the queried id" do
      task  = FactoryGirl.create :task
      user = FactoryGirl.create(:external_project_link, project: task.story.iteration.project).accounts.first.user
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
      FactoryGirl.create(:external_project_link, project: unaccessable_task.story.iteration.project)
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      get "show", id: unaccessable_task.id

      response.status.should == 403
      result = ActiveSupport::JSON.decode response.body
      result["error"].should == I18n.t("request.forbidden")
    end
  end

  describe "modify" do
    it "allows partial modifications of tasks to be made" do
      task = FactoryGirl.create :task
      user = FactoryGirl.create(:external_project_link, project: task.story.iteration.project).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      
      #patch "modify", id: task.id, task: {status:"started"}

      put "modify", id: task.id, status: "started"

      #print "XXXXXXXXXXXXXX: #{response.body}"

      result = ActiveSupport::JSON.decode response.body

      task.reload
      task.started?.should == true
      result["task"]["status"].should eql "started"
    end

    it "denies modification of tasks that the user does not have access to" do
      unaccessable_task = FactoryGirl.create :task
      FactoryGirl.create(:external_project_link, project: unaccessable_task.story.iteration.project)
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      put "modify", id: unaccessable_task.id
      
      response.status.should == 403
      result = ActiveSupport::JSON.decode response.body
      result["error"].should == I18n.t("request.forbidden")
    end

    it "returns 404 when the task does not exist" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      put "modify", id: 9999
      response.status.should == 404
      result = ActiveSupport::JSON.decode response.body
      result["error"].should == I18n.t("request.not_found")
    end

    it "prevents modifications which would result in the task being invalid" do
      #Setup request
      task = FactoryGirl.create :task
      user = FactoryGirl.create(:external_project_link, project: task.story.iteration.project).accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token

      # Try to munt the task on the server
      put "modify", id: task.id, status: "invalid-state"

      # Check response is 400, and correct error msgs
      response.status.should == 400
      result = ActiveSupport::JSON.decode response.body
      task.status = "invalid-state"
      task.valid?
      result["error"].should == "#{I18n.t("request.bad_request")}: #{task.errors.full_messages}"

      # Check the task on the server is not munted
      get "show", id: task.id
      response.status.should == 200
      result = ActiveSupport::JSON.decode response.body
      result["task"]["status"].should eql("not_started")
    end

  end

end
