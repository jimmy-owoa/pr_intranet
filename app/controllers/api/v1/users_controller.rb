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
      if @user.update(user_params)
        Location::Country.set_office_country(@user, params[:office_address])
        render json: { success: true, message: "User updated" }, status: :ok
      else
        render json: { success: false, message: "Error"}, status: :unprocessable_entity
      end
    end

    def create_user
      @user = General::User.new(user_params)

      if @user.save
        Location::Country.set_office_country(@user, params[:office_address])
        render json: {  success: true, message: "User created" }, status: :created
      else
        render json: { success: false, message: "Error"}, status: :unprocessable_entity
      end
    end

    def destroy
      if @user.destroy
        render json: { success: true, message: "User deleted" }, status: :ok
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
        :last_name2, :email, :office_addres, :position, :id_exa_boss
      )
    end
  end
end
