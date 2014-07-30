Ppweb::Application.routes.draw do

  get "/about" => "home#about"
  get "/contact" => "home#contact"
  get "/jobs" => "home#jobs"

  get "/notifications" => "notifications#index", as: "notifications"

  get "/signup" => "users#signup", as: "signup"
  get "/login" => "users#login", as: "login"

  post "/create_login_session" => "users#create_login_session"
  delete "logout" => "users#logout", :as => "logout"

  get "/orders/new" => "orders#new", :as => "new_order"
  post "/checkout" => "orders#checkout", :as => "checkout"

  # settings center
  get "/settings" => redirect("/settings/profile")
  get "/account" => redirect("/settings/profile")
  get "/settings/profile" => "settings#profile", as: "set_profile"
  get "/settings/binding" => "settings#binding", as: "set_binding"
  get "/settings/payment" => "settings#payment", as: "set_payment"
  get "/settings/freetime" => "settings#freetime", as: "set_freetime"
  put "/settings/profile/:field" => "settings#update_profile"
  put '/settings/update_bean' => "settings#update_bean"
  put '/settings/update_freetime' => "settings#update_freetime"
  post '/settings/update_binding' => "settings#update_binding"

  resources :comments
  resources :events, only: [:new, :create] do
    get :autocomplete_user_username, :on => :collection
  end

  get "/timeline" => "events#index", as: "event_timeline"

  # blog
  get "/blog" => "blogs#index"
  get "/blog/:id" => "blogs#show", :as => "blog"
  get "/blog/:id/edit" => "blogs#edit", :as => "edit_blog"
  get "/write_blog" => "blogs#new"
  put "/blog/:id" => "blogs#update"
  resources :blogs

  # issues
  resources :issues

  # events
  get "/event/:uid" => "events#show", as: "event"
  get "/event/:uid/classroom" => "events#classroom"
  get "/event/:uid/edit" => "events#edit", as: "edit_event"
  put "/event/:uid/invite_guest" => "events#invite_guest", as: "invite_guest"
  post "/event/:uid/delete_guest" => "events#delete_guest", as: "delete_guest"
  post "/event/:uid/invite_guest_by_mail" => "events#invite_guest_by_mail", as: "invite_guest_by_mail"
  get "/event/:uid/invitation" => "events#invitation", as: "event_invitation"
  put "/event/:uid/:field" => "events#update_event"

  put '/event/:uid' => "events#update"
  post "/create_event_membership" => "events#event_membership", as: "event_membership"

  resources :users, only: [:create]
  resources :messages, only: [:create]

  get "/search" => "users#search", as: "search"

  mount Resque::Server, at: '/resque'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  get "/:username/attended_events" => "users#attended_events", as: "attended_events"
  get "/:username" => "users#show", as: "account"
  root to: "home#index"
end
