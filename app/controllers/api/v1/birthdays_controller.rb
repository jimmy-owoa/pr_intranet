module Api::V1
  class BirthdaysController < ApiController
    include ApplicationHelper

    def index
      page = params[:page]
      date = params[:date]

      if page && date        
        if date == "0"
          users = General::User.users_birthday_today.show_birthday
        else
          users = General::User.where("extract(month from birthday) = ?", date).order("DAY(birthday)").show_birthday
        end
        birthdays = users.order(:birthday).page(page).per(9)
        data_birthdays = []
        birthdays.each do |user|
          data_birthdays << {
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            full_name: get_full_favorite_name(user),
            email: user.email,
            annexed: user.annexed,
            company: user.company.present? ? user.company.name.titleize : "",
            birthday: l(user.birthday, format: "%d de %B").downcase,
            date: Date.today.year.to_s + "-" + user.birthday.strftime("%m-%d"),
            image: user.image.attached? ? url_for(user.image.variant(resize: "300x300>")) :  ActionController::Base.helpers.asset_path("default_avatar.png"),
            color: user.get_color,
          }
        end
        data = {status: 'ok', page: page || 1, birthdays: data_birthdays, birthday_length: data_birthdays.count}
        render json: data, status: :ok
      else
        render json: { status: 'error', message: 'bad request'}, status: :bad_request 
      end
    end

    def get_home_birthdays
      birthdays_users = General::User.users_birthday_today.show_birthday.sample(4)
      data_birthdays = []
      birthdays_users.each do |user|
        data_birthdays << {
          id: user.id,
          name: user.favorite_name.present? ? user.favorite_name : user.name,
          last_name: user.last_name,
          full_name: get_full_favorite_name(user),
          email: user.email,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          created_at: user.created_at,
          company: user.company.present? ? user.company.name.titleize : "",
          image: user.image.attached? ? url_for(user.image.variant(resize: "300x300>")) :  ActionController::Base.helpers.asset_path("default_avatar.png"),
          color: user.get_color,
        }
      end
      data = { status: 'ok', birthdays: data_birthdays, birthdays_length: data_birthdays.count }
      render json: data, status: :ok
    end
  end
end
