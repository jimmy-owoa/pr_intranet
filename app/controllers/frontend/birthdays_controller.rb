module Frontend
  class BirthdaysController < ApplicationController
    after_action :set_tracking, only: [:index, :list, :modal]

    def index
      # @users_calendar = General::User.show_birthday
      @months = I18n.t("date.month_names").drop(1).join(", ")
      users =  General::User.where('extract(month from birthday) = ?', Date.today.month)
      # users = General::User.where('created_at > ? and created_at < ?', 3.months.ago, -3.months.ago).where.not(birthday: nil).show_birthday
      data = []
      users.each do |user|
        data << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.name,
          last_name: user.last_name,
          full_name: user.name + ' ' + user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday.strftime("%d/%m/%Y"),
          date: Date.today.year.to_s + "-" + user.birthday.strftime("%m-%d"),
          show_birthday: user.show_birthday,
          image: user.image.attached? ? url_for(user.image.variant(resize: '300x300>')) : root_url + '/assets/default_avatar.png',
          open: false,
        }
      end
      respond_to do |format|
        format. html
        format.json { render json: data }
      end
    end

    def birthday_month
      # @users_calendar = General::User.show_birthday
      @months = I18n.t("date.month_names").drop(1).join(", ")
      users =  General::User.where('created_at > ? and created_at < ?', 3.months.ago, -3.months.ago).where.not(birthday: nil).show_birthday
      data = []
      users.each do |user|
        data << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.name,
          last_name: user.last_name,
          full_name: user.name + ' ' + user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday.strftime("%d/%m/%Y"),
          date: Date.today.year.to_s + "-" + user.birthday.strftime("%m-%d"),
          show_birthday: user.show_birthday,
          image: user.image.attached? ? url_for(user.image.variant(resize: '300x300>')) : root_url + '/assets/default_avatar.png',
          open: false,
        }
      end
      respond_to do |format|
        format. html
        format.json { render json: data }
      end
    end


    def get_home_birthdays
      data = []
      birthdays = General::User.where('extract(month from birthday) = ?', Date.today.month)
      birthdays_filtered = (birthdays.sort_by &:birthday).last(4)
      birthdays_filtered.each do |user|
        data << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.name,
          last_name: user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          show_birthday: user.show_birthday,
          company: user.company,
          image: user.image.attached? ? url_for(user.image.variant(resize: '300x300>')) : root_url + '/assets/default_avatar.png'
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
        @image = user.image.attached? ? url_for(user.image.variant(resize: '300x300>')) : root_url + '/assets/default_avatar.png'
        data << {
          id: user.id,
          email: user.email,
          name: user.name,
          last_name: user.last_name,
          full_name: user.name + ' ' + user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          show_birthday: user.show_birthday,
          image: @image,       
        }
      end
      respond_to do |format|
        format. html
        format.json { render json: data }
      end      
    end

    private

    def set_tracking
      ahoy.track "Birthday Model", params
    end    

    
  end
end
