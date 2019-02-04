module Admin
  class UsersController < ApplicationController
    layout 'admin'
    include Devise::Controllers::Helpers
    #user logged can create users
    prepend_before_action  :require_no_authentication, only: [:cancel ]
    #callbacks
    before_action :user_registered?
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    after_action :set_tracking, only: [:index, :show, :new]
    after_action :set_tracking_action, only: [:create, :update]

    def index
      add_breadcrumb "Usuarios", :admin_users_path
      @users = General::User.paginate(:page => params[:page], :per_page => 10)
    end

    def new
      add_breadcrumb "Usuarios", :admin_users_path
      @user = General::User.new
      @user.terms.build
      authorize @user
    end
    
    def create
      @user = General::User.new(user_params)
      respond_to do |format|
        if @user.save
          set_tags
          format.html { redirect_to admin_user_path(@user), notice: 'Usuario fue creado con éxito.'}
          format.json { render :show, status: :created, location: @user}
        else
          format.html {render :new}
          format.json {render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end   
      respond_to do |format|
        # user_params[:term_ids].map{ |e| e.gsub!(/[^0-9]/, '') }.reject(&:blank?)
        if @user.update(user_params)
          set_tags
          format.html { redirect_to admin_user_path(@user), notice: 'user was successfully updated.'}
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit}
          format.json { render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end

    def show
      add_breadcrumb "Usuarios", :admin_users_path
    end

    def edit
      add_breadcrumb "Usuarios", :admin_users_path
    end

    private

    def set_tracking
      ahoy.track "User Model", params
    end

    def set_tracking_action
      ahoy.track "User Model / Actions", controller: params[:controller], action: params[:action], user: params[:user][:email]
    end

    def set_tags
      term_names = params[:term_names]
      terms = []
      if term_names.present?
        term_names.uniq.each do |tag|
          terms << General::Term.where(name: tag, term_type: General::TermType.tag).first_or_create
        end
        @user.terms << terms
      end   
    end

    def set_user
      @user = General::User.find(params[:id])
    end

    def user_registered?
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end

    def user_params
      params.require(:user).permit(:id, :email, :name, :last_name, :company, :position, :active, :annexed, :birthday, :password, :password_confirmation, :image, :show_birthday, :parent_id, :lft, :rgt, :depth, :children_count,role_ids: [], term_ids: [])
    end

  end
end
