require 'spec_helper'

describe IterationsController do

  include ActionController::HttpAuthentication::Token

  describe "list" do
    it "returns all the iterations for a project" do
      epl = FactoryGirl.create(:external_project_link)
      it1 = FactoryGirl.create(:iteration, project: epl.project)
      it2 = FactoryGirl.create(:iteration, project: epl.project)
      user = epl.accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", project_id: it1.project
      response.status.should eql 200
      result = ActiveSupport::JSON.decode response.body
      result["iterations"].count.should eql 2
      result["iterations"].should =~ [it1, it2].as_json
    end

    it "/backlog returns the backlog (a list of all iterations after the current_iteration)" do
      epl = FactoryGirl.create(:external_project_link)
      project = epl.project
      current = FactoryGirl.create(:iteration, project: project)
      project.current_iteration_id = current.id
      backlog1 = FactoryGirl.create(:iteration, project: project)
      backlog2 = FactoryGirl.create(:iteration, project: project)
      project.current_iteration_id = current.id
      project.save!
      user = epl.accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", type: "backlog",  project_id: project
      response.status.should eql 200
      result = ActiveSupport::JSON.decode response.body
      result["iterations"].should =~ [backlog1, backlog2].as_json
    end

    it "/done returns all done iterations (a list of all iterations before the current_iteration)" do
      epl = FactoryGirl.create(:external_project_link)
      project = epl.project
      done1 = FactoryGirl.create(:iteration, project: project)
      done2 = FactoryGirl.create(:iteration, project: project)
      current = FactoryGirl.create(:iteration, project: project)
      project.current_iteration_id = current.id
      project.save!
      user = epl.accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", type: "done",  project_id: project
      response.status.should eql 200
      result = ActiveSupport::JSON.decode response.body
      result["iterations"].should =~ [done1, done2].as_json
    end


    it "returns 404:not_found if the iteration does not exist" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list", project_id: 99999
      response.status.should eql 404
      result = ActiveSupport::JSON.decode response.body
      result["error"].should eql "#{I18n.t('request.not_found')}"
    end

    it "returns 403:forbidden if the user is not authorized to access the projects iterations" do
      epl = FactoryGirl.create(:external_project_link)
      project = epl.project
      unauthorised_user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(unauthorised_user.auth_token)
      get "list", project_id: project.id
      response.status.should eql 403
      result = ActiveSupport::JSON.decode response.body
      result["error"].should eql "#{I18n.t('request.forbidden')}"
    end

    it "returns 400:bad_request if project_id query parameter is not present" do
      user = FactoryGirl.create(:user)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get "list"
      response.status.should eql 400
      result = ActiveSupport::JSON.decode response.body
      result["error"].should eql "#{I18n.t('request.bad_request')}: project_id is required."
    end
  end

  describe "show" do
    # it "/current returns the current iteration" do
    #   epl = FactoryGirl.create(:external_project_link)
    #   project = epl.project
    #   current = FactoryGirl.create(:iteration, project: project)
    #   project.current_iteration_id = current.id
    #   user = epl.accounts.first.user
    #   @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    #   get "show", type: "current",  project_id: project
    #   response.status.should eql 200
    #   result = ActiveSupport::JSON.decode response.body
    #   result["iteration"].should eql current.as_json
    # end

    it "returns an iteration including all its stories when queried with a valid id" do
      epl = FactoryGirl.create(:external_project_link)
      iteration = FactoryGirl.create(:iteration, project: epl.project)
      s1 = FactoryGirl.create(:story, iteration: iteration)
      s2 = FactoryGirl.create(:story, iteration: iteration)
      user = epl.accounts.first.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials user.auth_token
      get "show", id: iteration.id
      response.status.should eql 200
      result = ActiveSupport::JSON.decode response.body
      result["iteration"]["id"].should eql iteration.id
      result["iteration"]["stories"].should =~ [s1, s2].as_json
    end
  end
end
