Rails.application.routes.draw do
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  devise_for :users,
  controllers: {
    sessions: "users/sessions",
    registrations: "admin/users"
  }, class_name: "General::User"
  namespace :admin do
    put 'upload/put', to: 'attachments#upload' 
    get 'analytics', to: 'analytics#index'
    resources :term_relationships
    resources :comments
    resources :links
    resources :attachments
    resources :terms
    resources :galleries
    resources :births
    resources :surveys
    resources :answers
    resources :menus
    resources :products do
      member do
        delete :delete_image
      end      
    end
    resources :posts do
      resources :attachments, only: [:create, :new]
      resources :galleries, only: [:create, :new]
      get :deleted, on: :collection
    end
    resources :term_types
    resources :users
    root to: 'application#index'
  end
  namespace :frontend, :defaults => { :format => 'json'} do
    get 'menus/index'
    get 'welcome/users', to: 'welcomes#users'
    get 'welcome/users_welcome', to: 'welcomes#users_welcome'
    get 'welcome/get_home_welcome', to: 'welcomes#get_home_welcome'
    get "searchv", to: "search#search_vue"
    get "searchm", to: "search#search_menu"
    get "search", to: "search#search"
    get 'indicators', to: 'application#indicators'
    get 'weather', to: 'application#weather'
    resources :users, only: [:update, :show] do
      get :user, on: :collection
    end
    resources :surveys
    resources :answers
    resources :links
    resources :birthdays do
      get :users_birthday, on: :collection
      get :get_home_birthdays, on: :collection
    end
    resources :products
    resources :posts, only: [:show, :index]
    resources :births do 
      get :get_home_births, on: :collection
    end
    root to: 'application#index'
  end
end
