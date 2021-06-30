module Api::V1
  class WelcomesController < ApiController
    include ApplicationHelper

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

    def meta_attributes(collection)
      {
        size: collection.size,
        current_page: collection.current_page,
        next_page: collection.next_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end
  end
end
