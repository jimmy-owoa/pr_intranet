Rails.application.routes.draw do
  devise_for :users, class_name: "General::User", controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  namespace :admin do
    post "upload", to: "attachments#upload"
    get "users/images_approbation", to: "users#images_approbation"
    get "analytics", to: "analytics#index"
    get "search", to: "search#search"
    
    resources :profiles do
      get :users_list, on: :member
    end

    resources :users

    resources :helpcenter_questions do
      get :subcategories, on: :collection
    end
    resources :helpcenter_categories do
      get :assistants, on: :member
    end
    resources :helpcenter_tickets do
      put :take_ticket, on: :member
      put :close, on: :member
      resources :helpcenter_messages, on: :member, only: [:create]
    end

    root to: "helpcenter_tickets#index"
  end
  namespace :api, :defaults => { :format => "json" } do
    namespace :v1, :defaults => { :format => "json" } do

      get 'current_user_azure', to: 'api#current_user_azure'
      resources :users, only: [:update, :show] do
        get :user, on: :collection
        get :current_user_vue, on: :collection
        get :current_user_vue_temp, on: :collection
        get :parents_data, on: :collection
      end
    end
    root to: "application#index"
  end

  root to: "helpcenter_tickets#index"
end
