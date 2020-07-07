Rails.application.routes.draw do
  devise_for :users, class_name: "General::User", controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  namespace :admin do
    post "upload", to: "attachments#upload"
    get "users/images_approbation", to: "users#images_approbation"
    get "analytics", to: "analytics#index"
    get "search", to: "search#search"
    get "searchatt", to: "attachments#search_att"
    get "searchvideo", to: "attachments#search_video"
    get "searchgall", to: "galleries#search_galleries"
    get "births/no_approved_index", to: "births#no_approved_index"
    get "products/no_approved_index", to: "products#no_approved_index"
    get "products/approved_index", to: "products#approved_index"
    get "menus/testing", to: "menus#testing"
    get "menus/html", to: "menus#html", :defaults => { :format => "json" }
    get "attachments/images", to: "attachments#index_images"
    get "attachments/videos", to: "attachments#index_videos"
    post "galleries/create_gallery", to: "galleries#create_gallery_post"
    get "new_video_post", to: "attachments#new_video"
    get "show_image_user", to: "users#show_image_user"
    resources :books
    resources :authors
    resources :editorials
    resources :user_book_relationships, only: [:index, :show, :destroy]
    resources :benefit_groups, only: [:show, :index]
    resources :term_relationships
    resources :comments
    resources :links
    resources :attachments
    resources :backgrounds
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
    resources :benefits, only: [:show, :edit, :update, :index]
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
  namespace :api, :defaults => { :format => "json" } do
    namespace :v1, :defaults => { :format => "json" } do
      post "answers_save_from_vue", to: "answers#answers_save_from_vue"
      post "answers_options_save_from_vue", to: "answers#answers_options_save_from_vue"
      post "answers_options_multiple_save_from_vue", to: "answers#answers_options_multiple_save_from_vue"
      post "check_data", to: "answers#check_data"
      get "menus", to: "menus#index"
      get "api_menu_mobile", to: "menus#api_menu_mobile"
      get "api_menu_mobile_chile", to: "menus#api_menu_mobile_chile"
      get "santorals", to: "santorals#santorals"
      get "welcome", to: "welcomes#index"
      get "welcome/get_home_welcome", to: "welcomes#get_home_welcome"
      get "searchv", to: "search#search_vue"
      get "searchm", to: "search#search_menu"
      get "autocomplete_user", to: "users#autocomplete_user"
      get "indicators", to: "api#indicators"
      get "menus/api_menu_vue(/:ln_user)", to: "menus#api_menu_vue"
      get "menus/api_menu_vue_chile", to: "menus#api_menu_vue_chile"
      get "menus/get_gospel_menu/:days", to: "menus#get_gospel_menu"
      get "sso_auth/:token", to: "users#set_user"
      get "sso_user_auth", to: "users#sso_user_auth"
      get "test_sso", to: "users#test_sso"
      get "user_messages", to: "user_messages#index"
      post "user_message/update", to: "user_messages#update"
      get "azure_auth", to: "api#azure_auth"
      get "current_user_azure", to: "api#current_user_azure"
      get "products/user_products", to: "products#user_products"
      get "posts_video", to: "posts#index_video"
      get "posts_video/post", to: "posts#post_video"
      get "last_posts", to: "posts#last_posts"
      get "moments/latest_moments", to: "galleries#index"
      resources :library do
        get :get_categories, on: :collection
      end
      post "library/create_request_book", to: "library#create_request_book"
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
        get :get_home_birthdays, on: :collection
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
    end
    root to: "application#index"
  end
end
