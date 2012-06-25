require 'spec_helper'

describe UserController do

  it_behaves_like "an_api_controller", "/user", [:get, :post]
  it "routes /user" do
    post("/user").should route_to("user#create")
  end

  it "routes to #show" do
    u = User.new(name:"Testy")
    u.save!
    get("/user?auth_token=#{u.authentication_token}").should route_to("user#show")
  end
end

