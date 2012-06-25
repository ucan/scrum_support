ScrumSupport::Application.routes.draw do

  devise_for :users, :skip => :sessions


  root :to => "root#index"  

  #User Controller
  get "/user" => "user#show" # use token for auth and user retrieval

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
  


  #get "/project/:id/story" => "story#list_for_project", :constraints => { :id => /\d+/ }

  # get "/user/setup" => "user#setup" #add some shit to the db for testing purposes

  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
