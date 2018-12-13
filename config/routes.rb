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
    resources :attachments
    resources :terms
    resources :galleries
    resources :births
    resources :surveys
    resources :answers
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
  namespace :frontend do
    get 'welcome', to: 'welcomes#index'
    get 'welcome/users', to: 'welcomes#users', :defaults => { :format => 'json'}
    get 'modal_welcome', to: 'welcomes#modal'
    get "search", to: "search#search"
    get "searchv", to: "search#search_vue", :defaults => { :format => 'json'}
    get 'indicators', to: 'application#indicators', :defaults => { :format => 'json'}
    post 'uploader/image', to: 'application#image'
    resources :users, only: [:update, :show], :defaults => { :format => 'json'} do
      get :id_user, on: :collection
    end
    resources :surveys, defaults: {format: :json}
    resources :answers
    resources :birthdays, only: [:index], defaults: {format: :json} do
      get :list, on: :collection
      get :modal, on: :collection
      get :calendar, on: :collection, defaults: {format: :json} 
    end
    resources :products, :defaults => { :format => 'json'}
    resources :posts, only: [:show, :index], :defaults => { :format => 'json'}
    resources :attachments, only: [:show, :index]
    resources :terms, only: [:show, :index]
    resources :term_types, only: [:show, :index]
    resources :term_relationships, only: [:show, :index]
    resources :births, :defaults => { :format => 'json'} do
      collection do
        get :list
      end
    end
    root to: 'application#index'
  end
end
