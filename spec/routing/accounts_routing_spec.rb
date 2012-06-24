require 'spec_helper'

describe AccountsController do
  it "routes to /list" do
    get("/accounts").should route_to("accounts#list")
  end

  it "routes to /create" do
    post("/accounts").should route_to("accounts#create")
  end

  it "routes to /show/n" do
  	u = User.new(name:"Testy")
  	u.save!
    get("/accounts/1?auth_token=#{u.authentication_token}").should route_to(:controller => "accounts", :action => "show", :id => "1")
  end
end