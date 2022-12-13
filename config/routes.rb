Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root "static_pages#home"
  get "/home", to: 'static_pages#home'
  get "/help", to: 'static_pages#help'
  get "/about", to: 'static_pages#about'
  get "/contact", to:'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Resources.
  resources :users 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  # Search a username and returns the User page. 
  get '/:username', to: 'users#show'
  get "/microposts", to: "static_pages#home"
end
