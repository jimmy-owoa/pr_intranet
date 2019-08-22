module Frontend
  class WelcomesController < FrontendController

    def welcomes_calendar
      users = General::User.users_welcome
      data= []
      users.each do |user|
        image = user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + ActionController::Base.helpers.asset_url('default_avatar.png')
        data << {
          id: user.id,
          email: user.email,
          full_name: user.name + ' ' + user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          company: user.company,
          date: user.date_entry.strftime("%Y-%m-%d"),
          image: image
        }
      end
      respond_to do |format|
        format.json {render json: data}
        format.js
      end
    end

    def get_home_welcome
      new_users = General::User.users_welcome.limit(4)
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
          image: user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + ActionController::Base.helpers.asset_url('default_avatar.png'),
          color: user.get_color
        }
      end
      respond_to do |format|
        format.json {render json: data}
        format.js
      end
    end

    def index
      page = params[:page]
      date = params[:date]
      if date == "0"
        new_users = General::User.where(date_entry: Date.today).order(date_entry: :asc)
      else
        new_users = General::User.where('extract(year from date_entry) = ?', Date.today.year).where('extract(month from date_entry) = ?', date).order(date_entry: :asc)
      end
      users = Kaminari.paginate_array(new_users).page(page).per(9)
      data= []
      users.each do |user|
        image = user.image.attached? ? url_for(user.image.variant(resize: '300x300')) : root_url + ActionController::Base.helpers.asset_url('default_avatar.png')
        data << {
          id: user.id,
          email: user.email,
          full_name: user.name + ' ' + user.last_name,
          active: user.active,
          annexed: user.annexed,
          birthday: user.birthday,
          company: user.company.present? ? user.company : 'Sin información',
          date_entry: l(user.date_entry, format: "%d de %B").downcase,
          image: image,
          color: user.get_color
        }
      end
      respond_to do |format|
        format.json { render json: {hits: data} }
        format.js
      end    
    end
  end 
end 