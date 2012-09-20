require 'spec_helper'

describe ProjectsController do

  include ActionController::HttpAuthentication::Token

  describe "list" do
    it "should return all the projects for a user" do
      external_project_link1 = FactoryGirl.create(:external_project_link)
      project1 = external_project_link1.project
      account1 = external_project_link1.accounts[0]
      user = account1.user

      external_project_link2 = FactoryGirl.create(:external_project_link)
      project2 = external_project_link2.project
      account2 = external_project_link2.accounts[0]
      user.accounts << account2
      
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :list
      result = ActiveSupport::JSON.decode(response.body)
      result["projects"].should =~ [project1, project2].as_json
    end
  end

  describe "show" do  
    it "should return a list of iterations for a project" do
      it1 = FactoryGirl.create(:iteration)
      project = it1.project
      it2 = FactoryGirl.create(:iteration, project: project)
      external_project_link = FactoryGirl.create(:external_project_link, project: project)
      user = external_project_link.accounts[0].user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, {id: project.id }
      result = ActiveSupport::JSON.decode(response.body)
      result["project"]["iterations"].should =~ [it1, it2].as_json
    end

    it "should return a list of members for a project" do
      tm1 = FactoryGirl.create(:team_member)
      tm2 = FactoryGirl.create(:team_member)
      project = FactoryGirl.create(:project)
      project.team_members << tm1 << tm2
      external_project_link = FactoryGirl.create(:external_project_link, project: project)
      user = external_project_link.accounts[0].user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, {id: project.id }
      result = ActiveSupport::JSON.decode(response.body)
      result["project"]["team_members"].should =~ [tm1, tm2].as_json
    end

    it "should provide an error if the project id is not valid" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, { id: 999999 }
      result = ActiveSupport::JSON.decode response.body
      response.status.should eql 404
      result["error"].should eql I18n.t 'request.not_found'
    end

    it "should only allow access to the authenticated users stories" do
      story = FactoryGirl.create :story
      project = story.iteration.project
      external_project_link = FactoryGirl.create(:external_project_link, project: project)

      different_user = FactoryGirl.create :user

      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(different_user.auth_token)
      get :show, {id: project.id }
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should_not eql nil
      result["error"].should eql I18n.t('request.forbidden')
    end
  end
end
