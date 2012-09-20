class RootController < ApplicationController

  def index
    links = { links:
              {  user: "/user",
                 accounts: "/accounts",
                 iterations: "/iterations",
                 projects: "/projects",
                 stories: "/stories",
                 tasks: "/tasks"
                 }
              }
    render json: links
  end
end
