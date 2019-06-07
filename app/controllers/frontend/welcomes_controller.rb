module Frontend
  class WelcomesController < FrontendController
  before_action :authenticate_user!, only: [:index]

  def users
    @new_users = General::User.first_welcome
    data= []
    @new_users.each do |user|
      data << {
        id: user.id,
        email: user.email,
        created_at: user.created_at,
        name: user.name.titleize,
        last_name: user.last_name.titleize,
        active: user.active,
        annexed: user.annexed,
        birthday: user.birthday.strftime("%d/%m/%Y"),
        show_birthday: user.show_birthday,
        image: url_for(user.image.variant(resize: '300x300'))
      }
    end
    respond_to do |format|
      format.json {render json: data}
      format.js
    end
  end

  def get_home_welcome
    new_users = General::User.users_welcome
    data = []
    new_users.each do |user|
      data << {
        id: user.id,
        email: user.email,
        created_at: user.created_at,
        name: user.name.capitalize,
        last_name: user.last_name.titleize,
        active: user.active,
        annexed: user.annexed,
        birthday: user.birthday,
        company: user.company.present? ? user.company.titleize : nil,
        date: user.date_entry.present? ? user.date_entry.strftime("%Y-%m-%d") : user.date_entry,
        show_birthday: user.show_birthday,
        image: user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + '/assets/default_avatar.png'
      }
    end
    respond_to do |format|
      format.json {render json: data}
      format.js
    end
  end

  def users_welcome
    @new_users = General::User.where('date_entry > ? and date_entry < ?', 3.months.ago, -3.months.ago)
    data= []
    @new_users.each do |user|
      @image = user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + '/assets/default_avatar.png'
      data << {
        id: user.id,
        email: user.email,
        full_name: user.name + ' ' + user.last_name,
        active: user.active,
        annexed: user.annexed,
        birthday: user.birthday,
        company: user.company,
        date: user.date_entry.strftime("%Y-%m-%d"),
        image: @image
      }
    end
    respond_to do |format|
      format.json {render json: data}
      format.js
    end    
  end
end 
end 
