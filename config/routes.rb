Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#new'
  #login
  get   '/login',  to: 'sessions#new'
  post  '/login',  to: 'sessions#create'
  delete'/logout', to: 'sessions#destroy' 
  
  delete'/deleteuser', to: 'users#destroy' 
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  #userresource
  resources :users
  #AcountActivations
  resources :account_activations , only: [:edit]
  #Passwordresets
  resources :password_resets, only: [:new, :create, :edit, :update]  
  #microposts
  resources :microposts,  only: [:create, :destroy]
  #relationships
  resources :relationships, only: [:create, :destroy]
end