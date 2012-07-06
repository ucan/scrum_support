require 'spec_helper'

describe ApplicationController do

  include ActionController::HttpAuthentication::Token

  before(:all) do
    Rails.application.routes.draw do
      match '/authenticate' => "application#authenticate"
      match '/user_from_auth_token' => "application#user_from_auth_token"
    end
  end

  after(:all) do
    Rails.application.reload_routes! #Reset routes to prevent mucking up routes for other tests
  end

  describe "authenticate" do
    it "should return http 401:forbidden for unauthenticated users" do
      get :authenticate
      response.status.should eql 401
    end

    it "should return nil for authenticated users" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      get :authenticate
      response.status.should eql 200
    end
  end

  describe "current_user" do
    it "should return the currently authenticated user" do
      user = FactoryGirl.create :user
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      result = controller.current_user
      result.should eql user
    end
  end
end
