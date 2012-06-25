require 'spec_helper'

describe StoriesController do
  it "routes to /show/n" do
  	u = User.new(name:"Testy")
  	u.save!
    get("/stories/1?auth_token=#{u.authentication_token}").should route_to(:controller => "stories", :action => "show", :id => "1")
  end
end