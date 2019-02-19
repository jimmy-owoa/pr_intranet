class Frontend::WelcomesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def users
    @new_users = General::User.first_welcome
    data= []
    @new_users.each do |user|
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
        image: root_url + rails_representation_url(user.image.variant(resize: '300x300'), only_path: true)
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
        name: user.name,
        last_name: user.last_name,
        active: user.active,
        annexed: user.annexed,
        birthday: user.birthday,
        company: user.company,
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
    @new_users = General::User.last(20)
    data= []
    @new_users.each do |user|
      @image = user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + '/assets/default_avatar.png'
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
        image: @image
      }
    end
    respond_to do |format|
      format.json {render json: data}
      format.js
    end    
  end

end
