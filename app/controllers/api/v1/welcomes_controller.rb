module Api::V1
  class WelcomesController < ApiController
    def home_welcome
      users = General::User.users_welcome.limit(4)

      render json: users,each_serializer: UserSerializer, status: :ok
    end

    def index
      page = params[:page] || 1
      month = params[:month] || 1

      users = General::User.get_welcomes_users(page, month)
      data = ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserSerializer, is_welcome_index: true)

      render json: { data: data, meta: meta_attributes(users) }, status: :ok
    end
  end
end
