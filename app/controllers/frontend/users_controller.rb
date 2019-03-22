class Frontend::UsersController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :set_user, only: [:update]

  def nickname(name)
    name.match(/^([jJ]os.|[jJ]uan|[mM]ar.a) /).present?  ? name : name.split.first
  end

  def user
    id = params[:id].present? ? params[:id] : nil
    # datos hardcodeados hasta tener data de users
    @user = General::User.find(id)
    @nickname = nickname(@user.name)
    data_user = []
    data_childrens = []
    data_siblings = []
    data_father = []
    if @user.children.first.present?
      @user.children.where.not(parent_id: nil).each do |children|
        data_childrens << {
          id: children.id,
          name: children.name,
          last_name: children.last_name, 
          position: children.position,
          company: children.company,          
          image: children.image.attached? ?
          url_for(children.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
        }
      end
    end
    if @user.siblings.first.present?
      @user.siblings.where.not(parent_id: nil).each do |sibling|
        data_siblings << {
          id: sibling.id,
          name: sibling.name,
          last_name: sibling.last_name,
          position: sibling.position,
          company: sibling.company,          
          image: sibling.image.attached? ? 
          url_for(sibling.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
        }
      end
    end
    if @user.parent.present?
      data_father << {
        id: @user.parent.id,
        name: @user.parent.name,
        last_name: @user.parent.last_name,
        position: @user.parent.position,
        company: @user.parent.company,        
        image: @user.parent.image.attached? ? 
        url_for(@user.parent.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
      }
    end
    data_user << {
      id: @user.id,
      name: @user.name,
      nickname: @nickname,
      last_name: @user.last_name,
      email: @user.email,
      annexed: @user.annexed,
      position: @user.position,
      company: @user.company,
      address: @user.address,
      image: @user.image.attached? ? 
      url_for(@user.image) : root_url + '/assets/default_avatar.png',
      tags: @user.terms.tags.map(&:name),
      categories: @user.terms.categories.map(&:name),
      childrens: data_childrens,
      siblings: data_siblings,
      father: data_father,
      breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '#', name: (@user.name + ' ' + @user.last_name).truncate(30)}
        ]
    }
    respond_to do |format|
      format.json { render json: data_user }
      format.js
    end
  end

  def current_user_vue
    data_user = []
    id = params[:id].present? ? params[:id] : nil
    @user = General::User.find(id)    
    @location = General::Location.where(name: @user.address).last
    @today =  Date.today.strftime("%d/%m/%Y")
    @tomorrow = (Date.today + 1.days).strftime("%A")
    @tomorrow_1 = (Date.today + 2.days).strftime("%A")
    @tomorrow_2 = (Date.today + 3.days).strftime("%A")
    @tomorrow_3 = (Date.today + 4.days).strftime("%A")
    @weather = General::WeatherInformation.where(location_id: @location).last
    @nickname = nickname(@user.name)
    data_user << {
      id: @user.id,
      nickname: @nickname,
      image: @user.image.attached? ?
      url_for(@user.image) : root_url + '/assets/default_avatar.png',
      email: @user.email,
      annexed: @user.annexed,
      breadcrumbs: [
        {link: '/', name: 'Inicio' },
        {link: '#', name: @nickname}
      ],
      location: @location.name,
      weather: @weather,
      today:  Date.today.strftime("%d/%m/%Y"),
      tomorrow: l(Date.today + 1, format: '%A'),
      tomorrow_1: l(Date.today + 2, format: '%A'),
      tomorrow_2: l(Date.today + 3, format: '%A'),
      tomorrow_3: l(Date.today + 4, format: '%A')
    }
    respond_to do |format|
      format.json { render json: data_user[0] }
      format.js
    end    
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        format.json
      else
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end    
  end
  
  def upload
    user = General::User.find(params[:user_id])
    user.image.attach(params[:file])
  end


  private

  def set_user
    @user = General::User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :name, :company, :position, :address, image: [], file:[])
  end
end