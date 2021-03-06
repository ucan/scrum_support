require 'spec_helper'

describe TasksController do
  describe "/tasks" do
    it_behaves_like "an_api_controller", "/tasks", [:get]

    it "routes to #list" do
      get("/tasks").should route_to "tasks#list"
    end
  end

  describe "/tasks/{id}" do
    it_behaves_like "an_api_controller", "/tasks/1", [:get, :put, :patch]

    it "routes to #show" do
      get("/tasks/1").should route_to controller: "tasks", action: "show", id:"1"
    end

    it "routes to #modify" do
      pending "need to figure out how to test this"
    end
  end

end
