require 'spec_helper'

describe TasksController do
  describe "/tasks" do
    it_behaves_like "an_api_controller", "/tasks", [:get]

    it "routes to #list" do
      get("/tasks").should route_to "tasks#list"
    end
  end

end
