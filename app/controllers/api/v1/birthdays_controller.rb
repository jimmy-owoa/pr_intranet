module Api::V1
  class BirthdaysController < ApiController
    def index
      page = params[:page] || 1
      month = params[:month] || 0

      users = General::User.get_birthday_users(page, month)
      data = ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserSerializer, birthdays_index: true)

      render json: { data: data, meta: meta_attributes(users) }, status: :ok
    end

    def home_birthdays
      users = General::User.users_birthday_today.show_birthday.sample(4)
      
      render json: users, each_serializer: UserSerializer, status: :ok
    end
  end
end
