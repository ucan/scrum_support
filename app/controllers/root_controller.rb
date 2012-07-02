class RootController < ApplicationController

  def index
    links = { links:
              {  user: "/user",
                 accounts: "/accounts",
                 projects: "/projects",
                 stories: "/stories",
                 tasks: "/tasks"
                 }
              }
    render json: links
  end
end
