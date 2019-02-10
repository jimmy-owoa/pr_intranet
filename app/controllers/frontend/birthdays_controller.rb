module Frontend
  class BirthdaysController < ApplicationController
    after_action :set_tracking, only: [:index, :list, :modal]

    def index
      # @users_calendar = General::User.show_birthday
      @months = I18n.t("date.month_names").drop(1).join(", ")
      users = General::User.with_attached_image.where("DATE_FORMAT(birthday, '%d/%m/%Y') = ?", Date.today.strftime("%d/%m/%Y"))
      data = []
      users.each do |user|
        data << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.name,
          last_name: user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday.strftime("%d/%m/%Y"),
          show_birthday: user.show_birthday,
          image: root_url + rails_representation_url(user.image.variant(resize: '300x300'), only_path: true),
        }
      end
      respond_to do |format|
        format. html
        format.json { render json: data }
      end
    end

    def get_home_birthdays
      data = []
      birthdays = (General::User.all.sort_by &:birthday).last(4)
      birthdays.each do |user|
        data << {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          name: user.name,
          last_name: user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday.strftime("%d/%m/%Y"),
          show_birthday: user.show_birthday,
          image: root_url + (user.image.attached? ? rails_representation_url(user.image.variant(resize: '300x300'), only_path: true) : '/assets/default_avatar.png')
        }
      end

      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end

    def calendar
      users = General::User.with_attached_image
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
          birthday: user.birthday,
          show_birthday: user.show_birthday,
          date: user.birthday
        }
      end
      respond_to do |format|
        format. html
        format.json { render json: data }
      end      
    end

    def users_birthday
      @users_calendar = General::User.show_birthday
      data = []
      @users_calendar.each do |user|
        @image = user.image.attachment.present? ? root_url + rails_representation_url(user.image.variant(resize: '300x300'), only_path: true) : nil
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
