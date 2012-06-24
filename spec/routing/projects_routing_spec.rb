require 'spec_helper'

describe ProjectsController do
  it "routes to /list" do
    get("/projects").should route_to("projects#list")
  end

  it "routes to /show/n" do
  	u = User.new(name:"Testy")
  	u.save!
    get("/projects/1?auth_token=#{u.authentication_token}").should route_to(:controller => "projects", :action => "show", :id => "1")
  end
end