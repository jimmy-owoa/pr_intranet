module Api::V1
  class BirthdaysController < ApiController
    include ApplicationHelper

    def index
      page = params[:page]
      date = params[:date]
      if date == "0"
        users = General::User.users_birthday_today.show_birthday
      else
        users = General::User.where("extract(month from birthday) = ?", date).order("DAY(birthday)").show_birthday
      end
      birthdays = users.order(:birthday).page(page).per(9)
      data = []
      birthdays.each do |user|
        data << {
          id: user.id,
          name: user.name,
          last_name: user.last_name,
          full_name: get_full_favorite_name(user),
          email: user.email,
          annexed: user.annexed,
          company: user.company.present? ? user.company.name.titleize : "",
          birthday: l(user.birthday, format: "%d de %B").downcase,
          date: Date.today.year.to_s + "-" + user.birthday.strftime("%m-%d"),
          image: user.image.attached? ? url_for(user.image.variant(resize: "300x300>")) : root_url + ActionController::Base.helpers.asset_url("default_avatar.png"),
          color: user.get_color,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: { hits: data } }
      end
    end

    def get_home_birthdays
      data = []
      birthdays_users = General::User.users_birthday_today.show_birthday.sample(4)
      birthdays_users.each do |user|
        data << {
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
          image: user.image.attached? ? url_for(user.image.variant(resize: "300x300>")) : root_url + ActionController::Base.helpers.asset_url("default_avatar.png"),
          color: user.get_color,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end

    def users_birthday
      @users_calendar = General::User.date_birth.show_birthday
      data = []
      @users_calendar.each do |user|
        @image = user.image.attached? ? url_for(user.image.variant(resize: "300x300>")) : root_url + ActionController::Base.helpers.asset_url("default_avatar.png")
        data << {
          id: user.id,
          name: user.name,
          last_name: user.last_name,
          full_name: get_full_favorite_name(user),
          email: user.email,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          show_birthday: user.show_birthday,
          image: @image,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
      end
    end
  end
end
