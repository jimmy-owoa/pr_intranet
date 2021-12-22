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
      get :subcategories, on: :collection
      put :take_ticket, on: :member
      put :close, on: :member
      resources :helpcenter_messages, on: :member, only: [:create]
    end

    root to: "helpcenter_tickets#index"
  end

  namespace :api, :defaults => { :format => "json" } do
    namespace :v1, :defaults => { :format => "json" } do
      resources :users, only: [:show] do
        # post 'login', to: 'users#sign_in'
        # delete 'sign_out', to: 'users#sign_out'
        # get 'current_user', to: 'users#current_user'
        post :sign_in, on: :collection
        delete :sign_out, on: :collection
        get :current_user_vue, on: :collection
      end

      post 'users', to: 'users#create_update'
      delete 'users', to: 'users#destroy'
      post 'hc_tickets', to: 'hc_tickets#is_approved'

      resources :hc_questions, only: [:show] do
        get :importants, on: :collection
        get :search, on: :collection
      end
  
      resources :hc_categories, param: :slug, only: [:index, :show]
      resources :hc_subcategories, param: :slug, only: [:show]
  
      resources :hc_tickets do
        resources :hc_messages, on: :member, only: [:create]
        resources :hc_satisfaction_answers, on: :member, only: [:create]
      end
    end
    
    root to: "application#index"
  end

  root to: "helpcenter_tickets#index"
end
