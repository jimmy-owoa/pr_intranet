module Frontend
  class UsersController < FrontendController
    include Rails.application.routes.url_helpers
    
    def nickname(name)
      name.match(/^([jJ]os.|[jJ]uan|[mM]ar.a) /).present?  ? name : name.split.first
    end

    def user
      data_user = []
      data_childrens = []
      data_siblings = []
      data_father = []
      id = params[:id].present? ? params[:id] : nil
      @user = General::User.find(id)
      @nickname = nickname(@user.name)
      # @location = @user.address.present? ? @user.address : General::Location.find(@user.location_id).name
      @location = General::Location.find(@user.location_id).name
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
        location: @location,
        date_entry: @user.date_entry,
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
      @location = General::Location.find(@user.location_id).name
      @today =  Date.today.strftime("%d/%m/%Y")
      @tomorrow = l(Date.today + 1, format: '%A')
      @tomorrow_1 = l(Date.today + 2, format: '%A')
      @tomorrow_2 = l(Date.today + 3, format: '%A')
      @tomorrow_3 = l(Date.today + 4, format: '%A')
      @weather = General::WeatherInformation.where(location_id: @user.location_id).last
      @nickname = nickname(@user.name)
      data_childrens = []
      data_siblings = []
      data_father = []
      data_benefits = []
      if @user.benefit_group.present?
        @user.benefit_group.benefits.each do |benefit|
          data_benefits << {
            id: benefit.id,
            name: benefit.title,
            content: benefit.content,
            image: benefit.image.attached? ? url_for(benefit.image) : root_url + '/assets/default_avatar.png'
        }
        end
      end
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
        last_name: @user.last_name,
        nickname: @nickname,
        date_entry: @user.date_entry,
        image: @user.image.attached? ?
        url_for(@user.image) : root_url + '/assets/default_avatar.png',
        email: @user.email,
        annexed: @user.annexed,
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '#', name: @nickname}
        ],
        address: @user.address,
        location: @location,
        weather: @weather,
        today:  @today,
        tomorrow: @tomorrow,
        tomorrow_1: @tomorrow_1,
        tomorrow_2: @tomorrow_2,
        tomorrow_3: @tomorrow_3,
        childrens: data_childrens,
        siblings: data_siblings,
        father: data_father,
        benefit_group: {
          name: @user.benefit_group.present? ? @user.benefit_group.name : 'Sin grupo beneficiario',
          benefits: data_benefits
        }
      }
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end    
    end
    
    # def parents_data
    #   id = params[:id].present? ? params[:id] : nil
    #   data = []
    #   data_childrens = []
    #   data_siblings = []
    #   data_father = []
    #   user = General::User.find(id)    
    #   if user.children.first.present?
    #     user.children.where.not(parent_id: nil).each do |children|
    #       data_childrens << {
    #         id: children.id,
    #         name: children.name,
    #         last_name: children.last_name, 
    #         position: children.position,
    #         company: children.company,          
    #         image: children.image.attached? ?
    #         url_for(children.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
    #       }
    #     end
    #   end
    #   if user.siblings.first.present?
    #     user.siblings.where.not(parent_id: nil).each do |sibling|
    #       data_siblings << {
    #         id: sibling.id,
    #         name: sibling.name,
    #         last_name: sibling.last_name,
    #         position: sibling.position,
    #         company: sibling.company,          
    #         image: sibling.image.attached? ? 
    #         url_for(sibling.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
    #       }
    #     end
    #   end
    #   if user.parent.present?
    #     data_father << {
    #       id: user.parent.id,
    #       name: user.parent.name,
    #       last_name: user.parent.last_name,
    #       position: user.parent.position,
    #       company: user.parent.company,        
    #       image: user.parent.image.attached? ? 
    #       url_for(user.parent.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
    #     }
    #   end
    #   data << {
    #     childrens: data_childrens,
    #     siblings: data_siblings,
    #     father: data_father
    #   }
    #   respond_to do |format|
    #     format.json { render json: data[0] }
    #     format.js
    #   end   
    # end

    def upload
      user = General::User.find(params[:user_id])
      image = params[:file]
      user.image.attach(image)
      user.base_64_exa(image)
    end

  end
end