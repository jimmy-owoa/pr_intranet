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
      @location = @user.location.present? ? General::Location.find(@user.location_id).name : 'No definido'
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
    
    def parents_data
      id = params[:id].present? ? params[:id] : nil
      user = General::User.find(id) 
      data_childrens = []
      data_siblings = []
      data_father = []
      data = []
      if user.children.first.present?
        user.children.where.not(parent_id: nil).each do |children|
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
      if user.siblings.first.present?
        user.siblings.where.not(parent_id: nil).each do |sibling|
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
      if user.parent.present?
        data_father << {
          id: user.parent.id,
          name: user.parent.name,
          last_name: user.parent.last_name,
          position: user.parent.position,
          company: user.parent.company,
          image: user.parent.image.attached? ?
          url_for(user.parent.image.variant(resize: '150x150')) : root_url + '/assets/default_avatar.png'
        }
      end
      data << {
        childrens: data_childrens,
        siblings: data_siblings,
        father: data_father,
      }
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end

    def current_user_vue
      data_user = []
      id = params[:full_legal_number].present? ? params[:full_legal_number] : nil
      rut= params[:full_legal_number]
      @user= General::User.find_by_legal_number(rut[0...-1])  
      @nickname = nickname(@user.name)
      data_benefits = []
      data_products = []
      data_messages = []
      if @user.benefit_group.present?
        data = { benefit_types: [] }
        @benefit_types = General::BenefitType.all
        @benefit_types.each do |benefit_type|
          allowed_benefits = benefit_type.benefits.allowed_by_benefit_group(@user.benefit_group.try(:id))
          if allowed_benefits.present?
            benefit_type_hash = {
              name: benefit_type.name,
              benefits: []
            }
            allowed_benefits.each do |benefit|
              benefit_type_hash[:benefits] << {
                id: benefit.id,
                name: benefit.title,
                content: benefit.content,
                image: benefit.image.attached? ? url_for(benefit.image) : root_url + '/assets/default_avatar.png',
              } 
            end
            data[:benefit_types] << benefit_type_hash
          end 
        end
      end
      if @user.products.present?
        @user.products.each do |product|
          data_products << {
            name: product.name ,
            description: product.description,
            product_type: product.product_type,
            price: product.price,
            email: product.email,
            phone: product.phone,
            location: product.location,
            expiration: product.expiration,
            approved: product.approved,
            user_id: product.user_id,
            is_expired: product.is_expired,
            published_date: product.published_date
          }
        end
      end
      if General::User.birthday?(@user.birthday)
        General::Message.where(message_type: 'birthdays').take(1).each do |message|
          data_messages << {
            id: message.id,
            title: message.title,
            content: message.content,
            message_type: message.message_type,
            is_const: message.is_const,
            image: message.image.attached? ? url_for(message.image) : root_url + '/assets/message.jpeg',
          }
        end
      end
      if General::User.welcome?(@user.id, @user.date_entry)
        General::Message.where(message_type: 'welcomes').take(1).each do |message|
          data_messages << {
            id: message.id,
            title: message.title,
            content: message.content,
            message_type: message.message_type,
            is_const: message.is_const,
            image: message.image.attached? ? url_for(message.image) : root_url + '/assets/message.jpeg',
          }
        end
      end
      data_user << {
        id: @user.id,
        name: @user.name,
        last_name: @user.last_name,
        full_legal_number: @user.legal_number + @user.legal_number_verification,
        nickname: @nickname,
        role: General::User.what_role?(@user),
        company: @user.company,
        date_entry: @user.date_entry,
        image: @user.image.attached? ?
        url_for(@user.image) : root_url + '/assets/default_avatar.png',
        companies: @user.terms.categories.map(&:name),
        including_tags: @user.terms.inclusive_tags.map{|a| a.name },
        excluding_tags: @user.terms.excluding_tags.map{|a| a.name },
        email: @user.email,
        annexed: @user.annexed,
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '#', name: @nickname}
        ],
        address: @user.address,
        location: @location,
        benefit_group: {
          name: @user.benefit_group.present? ? @user.benefit_group.name : 'Sin grupo beneficiario',
          benefits: data
        },
        products: data_products[0],
        messages: data_messages
      }
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end
    end

    def current_user_vue_temp
      data_user = []
      benefit_group = params[:group] if params[:group].present?
      id = General::BenefitGroup.where(name: benefit_group).first.general_users.first.id
      @user = General::User.find(id)
      @location = @user.location.present? ? General::Location.find(@user.location_id).name : 'No definido'
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
      data_products = []
      data_messages = []
      if @user.benefit_group.present?
        @user.benefit_group.benefits.each do |benefit|
          data_benefits << {
            id: benefit.id,
            name: benefit.title,
            content: benefit.content,
            image: benefit.image.attached? ? url_for(benefit.image) : root_url + '/assets/default_avatar.png',
            benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name : ''
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
      if @user.products.present?
        @user.products.each do |product|
          data_products << {
            name: product.name ,
            description: product.description,
            product_type: product.product_type,
            price: product.price,
            email: product.email,
            phone: product.phone,
            location: product.location,
            expiration: product.expiration,
            approved: product.approved,
            user_id: product.user_id,
            is_expired: product.is_expired,
            published_date: product.published_date
          }
        end
      end
      if General::User.birthday?(@user.birthday)
        General::Message.where(message_type: 'birthdays').take(1).each do |message|
          data_messages << {
            id: message.id,
            title: message.title,
            content: message.content,
            message_type: message.message_type,
            is_const: message.is_const,
            image: message.image.attached? ? url_for(message.image) : root_url + '/assets/message.jpeg',
          }
        end
      end
      if General::User.welcome?(@user.id, @user.date_entry)
        General::Message.where(message_type: 'welcomes').take(1).each do |message|
          data_messages << {
            id: message.id,
            title: message.title,
            content: message.content,
            message_type: message.message_type,
            is_const: message.is_const,
            image: message.image.attached? ? url_for(message.image) : root_url + '/assets/message.jpeg',
          }
        end
      end
      data_user << {
        id: @user.id,
        name: @user.name,
        last_name: @user.last_name,
        nickname: @nickname,
        company: @user.company,
        date_entry: @user.date_entry,
        image: @user.image.attached? ?
        url_for(@user.image) : root_url + '/assets/default_avatar.png',
        companies: @user.terms.categories.map(&:name),
        including_tags: @user.terms.inclusive_tags.map{|a| a.name },
        excluding_tags: @user.terms.excluding_tags.map{|a| a.name },
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
        benefits: {
          name: @user.benefit_group.present? ? @user.benefit_group.name : 'Sin grupo beneficiario',
          benefits: data_benefits
        },
        products: data_products[0],
        messages: data_messages
      }
      respond_to do |format|
        format.json { render json: data_user[0] }
        format.js
      end
    end

    def upload
      user = General::User.find(params[:user_id])
      image = params[:file]
      user.image.attach(image)
      user.base_64_exa(image)
    end

  end
end