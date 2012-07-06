require 'spec_helper'

describe ProjectsController do
  describe "/projects" do
    it_behaves_like "an_api_controller", "/projects", [:get]

    it "routes to /list" do
      get("/projects").should route_to("projects#list")
    end
  end
  describe "/projects/1" do

    it_behaves_like "an_api_controller", "/projects/1", [:get]
    it "routes to /show/n" do
      u = FactoryGirl.create(:user)
      get("/projects/1?auth_token=#{u.auth_token}").should route_to(controller: "projects", action: "show", id: "1")
    end
  end
end
