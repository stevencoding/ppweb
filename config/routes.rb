Ppweb::Application.routes.draw do
  # classroom
  get "/classroom" => "classrooms#show"
  # 1v1 chatroom
  get "/pproom/:roomname" => "classrooms#pproom", as: "pproom"

  get "notifications" => "notifications#index", as: "notifications"

  get "/signup" => "users#signup", as: "signup"
  get "/login" => "users#login", as: "login"

  post "/create_login_session" => "users#create_login_session"
  delete "logout" => "users#logout", :as => "logout"

  # settings center
  get "/settings" => redirect("/settings/profile")
  get "/account" => redirect("/settings/profile")
  get "/settings/profile" => "users#edit", as: "set_profile"
  get "/settings/payment" => "settings#payment", as: "set_payment"
  match "/settings/profile/:field" => "users#update_profile", only: [:put]

  resources :events do
    get :autocomplete_user_username, :on => :collection
  end
  get "/event/:uid" => "events#show", as: "event"
  get "/event/:uid/edit" => "events#edit", as: "edit_event"
  put "/event/:uid/invite_guest" => "events#invite_guest", as: "invite_guest"
  post "/event/:uid/delete_guest" => "events#delete_guest", as: "delete_guest"
  get "/event/:uid/invitation" => "events#invitation", as: "event_invitation"
  put "/event/:uid/:field" => "events#update_event"

  resources :events, only: [:new, :create]
  put '/event/:uid' => "events#update"
  post "/create_event_membership" => "events#event_membership", as: "event_membership"

  resources :users, only: [:create]

  get "/:username" => "users#show", as: "account"
  root to: "home#index"

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
