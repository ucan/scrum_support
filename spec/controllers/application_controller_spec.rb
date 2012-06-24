require 'spec_helper'

describe ApplicationController do

  describe "authenticate" do
    it "should return http 401:forbidden for unauthenticated users" do
      Rails.application.routes.draw do
        match '/authenticate' => "application#authenticate"
      end
      get :authenticate
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql I18n.t('request.unauthorized')
      response.status.should eql 401
      Rails.application.reload_routes! #Reset routes to prevent mucking up routes for other tests
    end

    it "should return ? for authenticated users" do
      user = User.new({:name => "matt"})
      user.save!

      controller = ApplicationController.new
      controller.params = {:auth_token => user.authentication_token}
      result = controller.authenticate

      result.should eql nil
    end
  end

  it "should return the currently authenticated user" do
    user = User.new({:name => "matt"})
    user.save!

    controller = ApplicationController.new
    controller.params = {:auth_token => user.authentication_token}
    result = controller.user_from_auth_token
    result.should eql user
  end
end
