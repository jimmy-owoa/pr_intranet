module Api::V1
  class WelcomesController < ApiController
    include ApplicationHelper

    def get_home_welcome
      new_users = General::User.users_welcome.limit(4)
      data_users = []
      new_users.each do |user|
        data_users << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.favorite_name.present? ? user.favorite_name : user.name,
          last_name: user.try(:last_name),
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          company: user.company.present? ? user.company.name.titleize : nil,
          date: user.date_entry.present? ? user.date_entry.strftime("%Y-%m-%d") : user.date_entry,
          show_birthday: user.show_birthday,
          image: user.image.attached? ? url_for(user.image.variant(resize: "300x300")) :  ActionController::Base.helpers.asset_path("default_avatar.png"),
          color: user.get_color,
        }
      end
      data = { status: 'ok', users: data_users, users_length: data_users.count }
      render json: data, status: :ok
    end

    def index
      page = params[:page]
      date = params[:date]

      if page && date
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
        data = {status: 'ok', page: page || 1, users: data_users, users_length: data_users.count}
        render json: data, status: :ok
      else
        render json: { status: 'error', message: 'bad request'}, status: :bad_request
      end
    end
  end
end
