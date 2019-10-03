Rails.application.routes.draw do
  devise_for :users, class_name: "General::User", controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  namespace :admin do
    post "upload", to: "attachments#upload"
    get "analytics", to: "analytics#index"
    get "search", to: "search#search"
    get "searchatt", to: "attachments#search_att"
    get "births/no_approved_index", to: "births#no_approved_index"
    get "products/no_approved_index", to: "products#no_approved_index"
    get "products/approved_index", to: "products#approved_index"
    get "menus/testing", to: "menus#testing"
    get "menus/html", to: "menus#html", :defaults => { :format => "json" }
    resources :benefit_groups
    resources :term_relationships
    resources :comments
    resources :links
    resources :attachments
    resources :terms
    resources :galleries
    resources :profiles do 
      get :users_list, on: :member
    end
    resources :births do
      member do
        put :permission_image
        delete :delete_image
      end
    end
    resources :surveys
    resources :files
    resources :benefits
    resources :benefit_groups
    resources :answers do
      get :report, on: :member
    end
    resources :menus
    resources :messages
    resources :sections
    put "products/update_expiration", to: "products#update_expiration"
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
    root to: "posts#index"
  end
  namespace :frontend, :defaults => { :format => "json" } do
    post "answers_save_from_vue", to: "answers#answers_save_from_vue"
    post "answers_options_save_from_vue", to: "answers#answers_options_save_from_vue"
    post "answers_options_multiple_save_from_vue", to: "answers#answers_options_multiple_save_from_vue"
    post "check_data", to: "answers#check_data"
    get "menus/menus"
    get "santorals/santorals"
    get "welcome", to: "welcomes#index"
    get "welcome/welcomes_calendar", to: "welcomes#welcomes_calendar"
    get "welcome/get_home_welcome", to: "welcomes#get_home_welcome"
    get "searchv", to: "search#search_vue"
    get "searchm", to: "search#search_menu"
    get "autocomplete_user", to: "users#autocomplete_user"
    get "indicators", to: "frontend#indicators"
    get "births/calendar_births", to: "births#calendar_births"
    get "menus/api_menu/:user_id(/:location_id)", to: "menus#api_menu"
    get "menus/api_menu_vue/:user_id(/:location_id)", to: "menus#api_menu_vue"
    get "sso_auth/:token", to: "users#set_user"
    get "sso_user_auth", to: "users#sso_user_auth"
    get "test_sso", to: "users#test_sso"
    get "user_messages", to: "user_messages#index"
    post "user_message/update", to: "user_messages#update"
    get "azure_auth", to: "frontend#azure_auth"
    resources :galleries
    resources :weather
    resources :users, only: [:update, :show] do
      get :user, on: :collection
      get :current_user_vue, on: :collection
      get :current_user_vue_temp, on: :collection
      get :parents_data, on: :collection
    end
    post "users/upload", to: "users#upload"
    post "products/update_expiration", to: "products#update_expiration"
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
      get :gallery, on: :collection
    end
    resources :births do
      get :get_home_births, on: :collection
    end
    root to: "application#index"
  end
end
