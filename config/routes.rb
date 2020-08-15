Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  get 'sessions/new'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
#   resources :users 
  
  resources :account_activations, only: [:edit]
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
#   resources :meetings, only: [:new, :show, :index, :create, :edit, :update, :destroy]
  
    resources :users do
     resources :meetings, only: [:index, :new, :create]
    end
    
  resources :meetings, only: [:show, :edit, :update, :destroy]
end
