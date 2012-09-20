require 'spec_helper'

describe AccountsController do

  include ActionController::HttpAuthentication::Token

  describe "list" do
    it "should be able to list accounts for a user" do
      user = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: user)
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :list
      result = ActiveSupport::JSON.decode(response.body)
      result["accounts"].should =~ [account].as_json
    end
  end

  describe "show" do
    it "returns an account with a list of all its projects" do
      account = FactoryGirl.create(:account)
      epl1 = FactoryGirl.create(:external_project_link)
      epl2 = FactoryGirl.create(:external_project_link)
      account.external_project_links << epl1 << epl2
      user = account.user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :show, { id: account.id }
      result = ActiveSupport::JSON.decode(response.body)
      result["account"]["id"].should eql account.id
      result["account"]["projects"].should =~ [epl1.project, epl2.project].as_json
    end

    it "does not allow access to other users accounts" do
      account1 = FactoryGirl.create :account
      user2 = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user2.auth_token)
      get :show, {id: account1.id }
      response.response_code.should eql 403
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should_not eql nil
      result["error"].should eql I18n.t('request.forbidden')
    end
  end

  describe "create" do
    it "provides 400 error for invalid request" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should include "#{I18n.t('request.bad_request')}: "
    end

    it "provides 400 error for pivotal tracker account type without email (or api_token)" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create, { type: "PtAccount", password: "holycrap"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: An email and password are required."
    end

    it "provides 400 error for pivotal tracker account type without password (or api_token)" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create, {type: "PtAccount", email: "yabababab@sdghkld.com"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: An email and password are required."
    end

    it "provides 401 error for incorrect email password combo" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create, {type: "PtAccount", email: "lordtestymctesticles@gmail.com", password: "wrong password"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 401
    end
  end
end
