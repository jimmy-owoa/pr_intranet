module Admin
  class UsersController < AdminController
    include Devise::Controllers::Helpers
    #user logged can create users
    prepend_before_action :require_no_authentication, only: [:cancel]
    #callbacks
    before_action :user_registered?
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      add_breadcrumb "Usuarios", :admin_users_path
      if params[:approved] == "true" || params[:approved] == "false"
        aprov = ActiveModel::Type::Boolean.new.cast(params[:approved])
        @users = General::User.active_filter(aprov).order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
      else
        @users = General::User.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
      end
    end

    def images_approbation
      @users = General::User.joins(:new_image_attachment)
    end

    def new
      add_breadcrumb "Usuarios", :admin_users_path
      @user = General::User.new
      @user.terms.build
      @companies = Company::Company.all
      authorize @user
    end

    def create
      @user = General::User.new(user_params)
      respond_to do |format|
        if @user.save
          set_tags
          format.html { redirect_to admin_user_path(@user), notice: "Usuario fue creado con éxito." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      aprove_new_image = params[:user][:approve_image]
      if params["approved"].present?
        respond_to do |format|
          @user.update_attributes(active: params[:approved])
          format.json { render :json => { value: "success" } and return }
        end
      elsif aprove_new_image.present?
        if aprove_new_image == "true"
          @user.image.attach(@user.new_image.blob)
          @user.profile_image_to_exa
          UserNotifierMailer.send_image_profile_changed(@user.email).deliver
        elsif aprove_new_image == "false"
          UserNotifierMailer.send_avatar_not_approved(@user.email).deliver
        end
        @user.new_image.purge()
        redirect_to admin_users_images_approbation_path
      else
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
        respond_to do |format|
          # user_params[:term_ids].map{ |e| e.gsub!(/[^0-9]/, '') }.reject(&:blank?)
          if @user.update(user_params)
            set_tags
            format.html { redirect_to admin_user_path(@user), notice: "Usuario fue actualizado con éxito." }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    def show
      add_breadcrumb "Usuarios", :admin_users_path
    end

    def edit
      @companies = Company::Company.all
      add_breadcrumb "Usuarios", :admin_users_path
    end

    def show_image_user
      @name = params[:user_name]
      @image = General::User.find(params[:user_id]).new_image.attachment.variant(resize: "x500").processed
      @user_id = params[:user_id]
      respond_to do |format|
        format.js
      end
    end

    private

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
      params.require(:user).permit(:id, :email, :name, :last_name, :last_name2, :company_id, :address, :position, :profile_ids,
                                   :active, :annexed, :birthday, :date_entry, :password, :password_confirmation, :image,
                                   :show_birthday, :parent_id, :lft, :rgt, :depth, :children_count, :legal_number, :location_id, role_ids: [], term_ids: [])
    end
  end
end
