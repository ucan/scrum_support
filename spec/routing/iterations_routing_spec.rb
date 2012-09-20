require 'spec_helper'

describe IterationsController do
  describe "/iterations" do
    it_behaves_like "an_api_controller", "/iterations", [:get]

    it "routes to /list" do
      get("/iterations").should route_to("iterations#list")
    end
  end

  # describe "/iterations/iteration_type" do
  #   it_behaves_like "an_api_controller", "/iterations/current", [:get]
    
  #   it "routes to /show/current" do
  #     u = FactoryGirl.create(:user)
  #     get("/iterations/current?auth_token=#{u.auth_token}").should route_to(controller: "iterations", action: "show", type: "current")
  #   end

  #   it "doesn't route to /show/not_a_valid_type" do
  #     u = FactoryGirl.create(:user)
  #     get("/iterations/not_a_valid_type?auth_token=#{u.auth_token}").should_not be_routable
  #   end
  # end

  describe "iterations/:id" do
    it_behaves_like "an_api_controller", "/iterations/1", [:get]

    it "routes to /show/:id" do
      u = FactoryGirl.create(:user)
      get("/iterations/1?auth_token=#{u.auth_token}").should route_to(controller: "iterations", action: "show", id: "1")
    end

    it "doesn't route to iterations/:not_a_valid_id" do
      u = FactoryGirl.create(:user)
      get("/iterations/65_plus_some_invalid_stuff?auth_token=#{u.auth_token}").should_not be_routable
    end

  end
end