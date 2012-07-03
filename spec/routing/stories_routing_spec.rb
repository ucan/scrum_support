require 'spec_helper'

describe StoriesController do
  it_behaves_like "an_api_controller", "/stories/1", [:get]

  it "routes to /show/n" do
  	u = FactoryGirl.create(:user)
  	u.save!
    get("/stories/1?auth_token=#{u.auth_token}").should route_to(controller: "stories", action: "show", id: "1")
  end
end
