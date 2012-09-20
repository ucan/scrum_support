require 'spec_helper'

describe StoriesController do

  include ActionController::HttpAuthentication::Token

  describe "list" do
    it "should allow a user to retrieve a list of stories for an iteration" do
      iteration = FactoryGirl.create(:iteration)
      epl = FactoryGirl.create(:external_project_link, project: iteration.project)
      s1 = FactoryGirl.create(:story, iteration: iteration)
      s2 = FactoryGirl.create(:story, iteration: iteration)
      user = epl.accounts[0].user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :list, iteration_id: iteration.id
      result = ActiveSupport::JSON.decode(response.body)
      result["stories"].should =~ [s1, s2].as_json
    end
  end

  describe "show" do
    it "should allow a user to retrieve a list of tasks for one of their stories" do
      story = FactoryGirl.create(:story)
      t1 = FactoryGirl.create(:task, story: story)
      t2 = FactoryGirl.create(:task, story: story)
      epl = FactoryGirl.create(:external_project_link, project: story.iteration.project)
      user = epl.accounts[0].user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, id: story.id
      result = ActiveSupport::JSON.decode(response.body)
      result["story"]["id"].should eql story.id
      result["story"]["tasks"].should =~ [t1, t2].as_json
    end

    it "handles and id that is not associated with a story" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, { id: 99999 }
      result = ActiveSupport::JSON.decode(response.body)
      response.status.should eql 404
      result["error"].should eql I18n.t('request.not_found')
    end
  end
end
