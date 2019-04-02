module Frontend
  class MenusController < FrontendController
    def menus
      data = []
      menus = General::Menu.menu_cached
      menus.each do |menu|
        data << {
          id: menu.id,
          title: menu.title,
          description: menu.description,
          css_class: menu.css_class,
          code: menu.code,
          priority: menu.priority,
          parent_id: menu.parent_id,
          link: menu.link,
          tags: menu.cached_tags,
          categories: menu.cached_categories,
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js      
      end
    end

    def api_menu 
      user_id = 3 # TODO: Cambiar al correcto
      location_id = 2 # TODO: Cambiar al correcto
      menus = General::Menu.all
      user = General::User.find(user_id)
      weather = General::WeatherInformation.current(location_id)
      location = General::Location.find(location_id) 
      santoral = General::Santoral.current
      data = {
        menus: menus,
        user: user,      
        weather: weather,
        santoral: santoral[0],
        location_name: location.name
      }
      menu_json = render_to_string(partial: 'api_client/menu.html.erb', layout: false, locals: data).to_json
      respond_to do |format|
        format.json { render json: menu_json }
      end
    end 
  end
end