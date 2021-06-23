module Api::V1
  class WelcomesController < ApiController
    include ApplicationHelper

    def home_welcome
      users = General::User.users_welcome.limit(4)

      render json: users,each_serializer: UserSerializer, status: :ok
    end

    def index
      page = params[:page]
      date = params[:date]

      if page.present? && date.present?
        if date == "0"
          new_users = General::User.where(date_entry: Date.today)
        else
          first_day_selected_month = Time.new(Time.now.year, date, 1, 0, 0, 0).to_date
          new_users = General::User.where(date_entry: first_day_selected_month..first_day_selected_month.end_of_month)
        end
        users = new_users.order(:date_entry).page(page).per(9)
        data_users = []
        users.each do |user|
          image = user.image.attached? ? url_for(user.image.variant(resize: "300x300")) :  ActionController::Base.helpers.asset_path("default_avatar.png")
          data_users << {
            id: user.id,
            email: user.email,
            full_name: get_full_favorite_name(user),
            active: user.active,
            annexed: user.annexed,
            birthday: user.birthday,
            company: user.company.present? ? user.company.name : "Sin información",
            date_entry: l(user.date_entry, format: "%d de %B").downcase,
            image: image,
            color: user.get_color,
          }
        end
        data = {status: "ok", page: page, results_length: data_users.count, date: date, users: data_users}
        render json: data, status: :ok
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end
  end
end
