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
    get 'welcome/users', to: 'welcomes#users', :defaults => { :format => 'json'}
    get "searchv", to: "search#search_vue", :defaults => { :format => 'json'}
    get 'indicators', to: 'application#indicators', :defaults => { :format => 'json'}
    resources :users, only: [:update, :show], :defaults => { :format => 'json'}
    resources :surveys, defaults: {format: :json}
    resources :answers, defaults: {format: :json}
    resources :birthdays, defaults: {format: :json} 
    resources :products, :defaults => { :format => 'json'}
    resources :posts, only: [:show, :index], :defaults => { :format => 'json'}
    resources :births, :defaults => { :format => 'json'}
    root to: 'application#index'
  end
end
