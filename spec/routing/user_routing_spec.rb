require 'spec_helper'

describe UserController do

  it_behaves_like "an_api_controller", "/user", [:get, :post]
  it "routes /user" do
    post("/user").should route_to("user#create")
  end

  it "routes to #show" do
    u = FactoryGirl.create(:user)
    get("/user?auth_token=#{u.auth_token}").should route_to("user#show")
  end

  it "doesn't accept delete requests" do
    u = FactoryGirl.create(:user)
    delete("/user?auth_token=#{u.auth_token}").should_not be_routable
  end

  it "doesn't accept put requests" do
    u = FactoryGirl.create(:user)
    put("/user?auth_token=#{u.auth_token}").should_not be_routable
  end
end
