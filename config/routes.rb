ScrumSupport::Application.routes.draw do

  #devise_for :users, :skip => :sessions

  root :to => "root#index", via: [:get] 

  #User Controller
  get "/user" => "user#show" # use email & password for auth_token retrieval
  post "/user" => "user#create"
  
  #Accounts Controller
  get "/accounts" => "accounts#list"
  get "/accounts/:id" => "accounts#show"

  post "/accounts" => "accounts#create" # post will contain the system to integrate with e.g type: "pt"

  
  #Projects Controller
  get "/projects" => "projects#list"
  get "/projects/:id" => "projects#show", :constraints => { :id => /\d+/ }

  
  #Stories Controller
  get "/stories/:id" => "stories#show", :constraints => { :id => /\d+/ }
end
