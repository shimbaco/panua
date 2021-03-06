Panua::Application.routes.draw do

  # Home
  get '/public_timeline' => 'home#public_timeline', :as => :home_public_timeline

  # Entry
  resources :entries, :only => :show

  # Comment
  resources :comments, :only => :create
  get '/comments/new/:parent_id' => 'comments#new_child', :as => :new_child_comment
  post '/comments/create/child' => 'comments#create_child', :as => :create_child_comment
  post '/comments/:type/:id' => 'comments#vote', :type => /(like|dislike)/, :as => :vote_comment
  delete '/comments/:type/:id' => 'comments#vote_cancel', :type => /(like|dislike)/, :as => :vote_comment_cancel

  # Bookmark
  get '/bookmarks/get_page_title' => 'bookmarks#get_page_title'
  resources :bookmarks

  # Setting
  namespace :settings do
    # User
    get 'user' => 'users#edit', :as => :edit_user
    put 'user/update' => 'users#update', :as => :update_user
    # Tag
    resources :tags
    # Service
    get 'services' => 'services#index', :as => :services
    get 'services/:provider_name/new' => 'services#new', :as => :services_new
    get 'services/:provider_name/create' => 'services#create', :as => :create_services
    get 'services/:provider_name/delete' => 'services#destroy', :as => :delete_service
  end

  # User
  devise_for :users do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
    get '/signup' => 'devise/registrations#new'
  end
  match '/home' => 'users#home'
  post '/users/follow/:id' => 'users#follow', :as => :follow_user
  delete '/users/remove/:id' => 'users#remove', :as => :remove_user
  match '/:screen_name' => 'users#profile', :screen_name => /[a-zA-Z0-9_]+/, :as => :profile
  match '/:screen_name/tags/*tags' => 'users#profile', :screen_name => /[a-zA-Z0-9_]+/
  match '/:screen_name/:follow' => 'users#following_followers', :screen_name => /[a-zA-Z0-9_]+/, :follow => /(following|followers)/, :as => :following_followers

  root :to => 'home#index'
end