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
    resources :expense_report_requests do
      put :take_request, on: :member
      put :close, on: :member
    end
    resources :expense_report_categories 
    resource :chat_messages
    resource :chat_rooms

    root to: "helpcenter_tickets#index"
  end

  namespace :api, :defaults => { :format => "json" } do
    namespace :v1, :defaults => { :format => "json" } do
      resources :users, only: [:show] do
        post :sign_in, on: :collection
        delete :sign_out, on: :collection
        get :current_user_vue, on: :collection
      end

      post 'users', to: 'users#create_update'
      delete 'users', to: 'users#destroy'
      get 'search/users', to: 'users#search'

      get 'societies', to: 'societies#societies'
      get 'categories', to: 'expense_report_categories#categories' 
      
      resources :hc_questions, only: [:show] do
        get :importants, on: :collection
        get :search, on: :collection
      end
      post 'expense_report_requests/review_request', to: 'expense_report_requests#review_request' 
      get 'expense_report_requests/response_request', to: 'expense_report_requests#response_request' 
      get 'expense_report_requests/divisas', to: 'expense_report_requests#divisas'
      get 'expense_report_requests/countries', to: 'expense_report_requests#countries'
      get 'expense_report_requests/accounts', to: 'expense_report_requests#accounts'
      get 'expense_report_requests/payment_method', to: 'expense_report_requests#payment_method'
      post 'expense_report_requests/save_draft_request', to: 'expense_report_requests#save_draft_request'
      get 'expense_report_requests/request_draft', to: 'expense_report_requests#request_draft'
      get 'expense_report_requests/request_user', to: 'expense_report_requests#request_user'
      resources :expense_report_requests do
        delete :destroy_file, on: :collection
        delete :destroy_invoice, on: :collection
      end
      resources :chat_messages, param: :slug, only: [:create]
      
      resources :hc_categories, param: :slug, only: [:index, :show]
      resources :hc_subcategories, param: :slug, only: [:show]
      
      resources :hc_tickets do
        get :divisas, on: :collection
        resources :hc_messages, on: :member, only: [:create]
        resources :hc_satisfaction_answers, on: :member, only: [:create]
      end
    end
    
    root to: "application#index"
  end

  root to: "application#index"
end
