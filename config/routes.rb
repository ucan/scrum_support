ScrumSupport::Application.routes.draw do

  get "iterations/list"

  get "iterations/show"

  #devise_for :users, skip: :sessions

  root to: "root#index", via: [:get]

  #User Controller
  get "/user" => "user#show" # use email & password for auth_token retrieval
  post "/user" => "user#create"
  #Accounts Controller
  get "/accounts" => "accounts#list"
  get "/accounts/:id" => "accounts#show"

  post "/accounts" => "accounts#create" # post will contain the system to integrate with e.g type: "pt"

  id_constraints  = { id: /\d+/ }
  #Projects Controller
  get "/projects" => "projects#list"
  get "/projects/:id" => "projects#show", constraints: id_constraints

  #Iterations Controller
  get "/iterations" => "iterations#list"
  get "/iterations/:id" => "iterations#show", constraints: id_constraints
  
  #Stories Controller
  get "/stories" => "stories#list"
  get "/stories/:id" => "stories#show", constraints: id_constraints

  #Tasks Controller
  get "/tasks" => "tasks#list"
  get "/tasks/:id" => "tasks#show", constraints: id_constraints

  put "/tasks/:id" => "tasks#modify", constraints: id_constraints  # TODO do we need patch? 
  match "/tasks/:id" => "tasks#modify", via: :patch, constraints: id_constraints
end
