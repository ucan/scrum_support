require 'spec_helper'

describe AccountsController do
  describe "/accounts" do
    it_behaves_like "an_api_controller", "/accounts", [:get, :post]

    it "routes to /list" do
      get("/accounts").should route_to("accounts#list")
    end

    it "routes to /create" do
      post("/accounts").should route_to("accounts#create")
    end
  end

  describe "/accounts/{id}" do
    it_behaves_like "an_api_controller", "/accounts/1", [:get]
  
    it "routes to /show/n" do
      u = FactoryGirl.create(:user) 
      get("/accounts/1?auth_token=#{u.auth_token}").should route_to(controller: "accounts", action: "show", id: "1")
    end
  end
end
