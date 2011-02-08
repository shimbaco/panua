Panua::Application.routes.draw do

  # Entry
  resources :entries, :only => :show

  # Comment
  resources :comments, :only => :create
  get '/comments/new/:parent_id' => 'comments#new_child', :as => :new_child_comment
  post '/comments/create/child' => 'comments#create_child', :as => :create_child_comment
  post '/comments/:type/:id' => 'comments#vote', :type => /(like|dislike)/, :as => :vote_comment
  delete '/comments/:type/:id' => 'comments#vote_cancel', :type => /(like|dislike)/, :as => :vote_comment_cancel

  # Bookmark
  resources :bookmarks

  # Setting
  namespace :settings do
    # User
    get 'user' => 'users#edit', :as => :edit_user
    put 'user/update' => 'users#update', :as => :update_user
    # Tag
    resources :tags
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