module Api
  class UsersController < ApiController
    before_action :find_user, except: %i[create index]

    def show
      render json: @user, status: :ok
    end

    def create
      @user = General::User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def find_user
      @user = General::User.find_by_legal_number!(params[:rut][0...-1])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "User not found" }, status: :not_found
    end

    def user_params
      params.permit(:email, :name, :last_name, :last_name2, :favorite_name, :company_id, :address, :position, :profile_ids,
                    :active, :annexed, :birthday, :date_entry, :password, :password_confirmation,
                    :show_birthday, :parent_id, :lft, :rgt, :depth, :children_count, :legal_number, :location_id)
    end
  end
end
