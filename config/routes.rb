# require 'sidekiq/web'

Rails.application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq'

  namespace :admin do
    resources :benefit_groups
  end
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  #authenticate jtw
  post 'authenticate', to: 'users/authentication#authenticate'
  #
  devise_for :users,
  controllers: {
    sessions: "users/sessions",
    registrations: "admin/users"
    }, class_name: "General::User"
    namespace :admin do
      post 'upload', to: 'attachments#upload'
      get 'analytics', to: 'analytics#index'
      get "search", to: "search#search"
      get "searchatt", to: "attachments#search_att"
      get 'births/no_approved_index', to: 'births#no_approved_index'
      get 'products/no_approved_index', to: 'products#no_approved_index'
      get 'products/approved_index', to: 'products#approved_index'
      get 'menus/testing', to: 'menus#testing'
      get 'menus/html', to: 'menus#html', :defaults => { :format => 'json' }
      resources :term_relationships
      resources :comments
      resources :links
      resources :attachments
      resources :terms
      resources :galleries
      resources :births do
        member do
          put :permission_image
          delete :delete_image
        end
      end
      resources :surveys
      resources :benefits
      resources :benefit_groups
      resources :answers do
        get :report, on: :member
      end
      resources :menus
      resources :messages
      resources :sections
      put 'products/update_expiration', to: 'products#update_expiration'
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
    root to: 'posts#index'
  end
  namespace :frontend, :defaults => { :format => 'json'} do
    post 'answers_save_from_vue', to: 'answers#answers_save_from_vue'
    post 'answers_options_save_from_vue', to: 'answers#answers_options_save_from_vue'
    post 'answers_options_multiple_save_from_vue', to: 'answers#answers_options_multiple_save_from_vue'
    post 'check_data', to: 'answers#check_data'
    get 'menus/menus'
    get 'santorals/santorals'
    get 'welcome', to: 'welcomes#index'
    get 'welcome/welcomes_calendar', to: 'welcomes#welcomes_calendar'
    get 'welcome/get_home_welcome', to: 'welcomes#get_home_welcome'
    get "searchv", to: "search#search_vue"
    get "searchm", to: "search#search_menu"
    get 'autocomplete_user', to: 'users#autocomplete_user'
    get 'indicators', to: 'frontend#indicators'
    get 'births/calendar_births', to: 'births#calendar_births'
    get 'menus/api_menu/:user_id(/:location_id)', to: 'menus#api_menu'
    resources :galleries
    resources :weather
    resources :users, only: [:update, :show] do
      get :user, on: :collection
      get :current_user_vue, on: :collection
      get :current_user_vue_temp, on: :collection
      get :parents_data, on: :collection
    end
    post 'users/upload', to: 'users#upload'
    post 'products/update_expiration', to: 'products#update_expiration'
    resources :surveys do
      get :survey_count, on: :collection
      get :survey, on: :collection
      get :user_surveys, on: :collection
    end
    resources :benefit_groups, only: [:index] do
      get :benefits_group, on: :collection
    end
    resources :answers
    resources :messages
    resources :links
    resources :sections
    resources :benefits do
      get :benefit, on: :collection
    end
    resources :birthdays do
      get :users_birthday, on: :collection
      get :birthday_month, on: :collection
      get :get_home_birthdays, on: :collection
      get :calendar, on: :collection
    end
    resources :products do
      get :product, on: :collection
    end
    resources :posts, only: [:show, :index] do
      get :post, on: :collection
      get :important_posts, on: :collection
    end
    resources :births do
      get :get_home_births, on: :collection
    end
    root to: 'application#index'
  end

end
