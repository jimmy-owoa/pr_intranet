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
      get "search", to: "search#search"
      get "searchatt", to: "attachments#search_att"
      resources :term_relationships
      resources :comments
      resources :links
      resources :attachments
      resources :terms
      resources :galleries
      resources :births do
        member do
          delete :delete_image
        end
      end
      resources :surveys
      resources :benefits
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
    post 'check_data', to: 'answers#check_data'
    get 'menus/index'
    get 'menus/menus'
    get 'santorals/santorals'
    get 'welcome/users', to: 'welcomes#users'
    get 'welcome/users_welcome', to: 'welcomes#users_welcome'
    get 'welcome/get_home_welcome', to: 'welcomes#get_home_welcome'
    get "searchv", to: "search#search_vue"
    get "searchm", to: "search#search_menu"
    get 'indicators', to: 'frontend#indicators'
    get 'weather', to: 'frontend#weather'
    get 'weather_info', to: 'weather_information#weather'
    get 'births/calendar_births', to: 'births#calendar_births'
    resources :users, only: [:update, :show] do
      get :user, on: :collection
      get :current_user_vue, on: :collection
    end
    post 'users/upload', to: 'users#upload'
    post 'products/update_expiration', to: 'products#update_expiration'
    resources :surveys do
      get :survey_count, on: :collection
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
    resources :products
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
