module Api::V1
  class UsersController < ApiController
    include Rails.application.routes.url_helpers
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:upload, :sign_in, :create_update, :destroy]
    skip_before_action :set_current_user_from_header, only: [:sign_in]
    before_action :set_user, only: [:create_update, :destroy]

    def sign_in
      user_code = params[:user][:user_code]
      return handle_400 if user_code.blank?
      
      id_exa = InternalAuth.decrypt(user_code) rescue ""
      user = General::User.find_by(id_exa: id_exa)
      return handle_400 if user.blank?
      
      render json: { success: true, token: user.as_json_with_jwt[:token] }
    end

    def current_user_vue
      data = ActiveModelSerializers::SerializableResource.new(request_user, serializer: UserSerializer)
      render json: { user: data }, status: :ok
    end

    def create_update
      @user.restore if @user.present? && @user.deleted_at.present?
      @user.present? ? update_user : create_user
    end

    def update_user
      params[:email] = @user.email if params[:email].blank?
      
      if @user.update(user_params)
        if @user.accounts.where(account_number: params[:payment_account][:account_number]).present?
          @user.accounts.where(account_number: params[:payment_account][:account_number]).first.update(params[:payment_account])
        else
          @user.accounts.create(params[:payment_account])
        end
        Location::Country.set_office_country(@user, params[:office_address])
        render json: { success: true, message: "User updated" }, status: :ok
      else
        render json: { success: false, message: "Error"}, status: :unprocessable_entity
      end
    end

    def create_user
      @user = General::User.new(user_params)
      @user.email = set_email if @user.email.blank?
      
      if @user.save
        @user.accounts.create(params[:payment_account])
        Location::Country.set_office_country(@user, params[:office_address])
        render json: {  success: true, message: "User created" }, status: :created
      else
        render json: { success: false, message: "Error"}, status: :unprocessable_entity
      end
    end

    def set_email
      email = "#{((0...8).map { (65 + rand(26)).chr }.join).downcase}@compass.cl"
      if General::User.find_by(email: email).present?
        set_email
      end
      email
    end

    def destroy
      if @user.destroy
        render json: { success: true, message: "User deleted" }, status: :ok
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    def search
      if params[:search].present? && params[:search].length > 2
        users = General::User.select(:id, :name, :last_name, :last_name2, :email, :legal_number, :country_id, :id_exa_boss).search(params[:search]).order(:name, :last_name, :last_name2)
        results = users.map {|u| { id: u.id, name: u.name + " " + u.last_name + " " + u.last_name2, email: u.email,legal_number: u.legal_number, country: u.country.name, id_exa_boss: General::User.find_by(id_exa: u.id_exa_boss).full_name } }
        render json: { success: true, users: results }, status: :ok
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end
    
    private

    def set_user
      begin
        id_exa = InternalAuth.decrypt(params[:user_code_crypted_base64])
        @user = General::User.with_deleted.find_by(id_exa: id_exa)
      rescue
        render json: { success: true, error: "Error" }, status: :unauthorized
      end
    end

    def user_params
      params.permit(
        :id_exa, :legal_number, :name, :last_name, 
        :last_name2, :email, :office_addres, :position, :id_exa_boss, :payment_account [:name, :account_number, :email, :legal_number, :bank_name, :account_type, :country]
      )
    end
  end
end
