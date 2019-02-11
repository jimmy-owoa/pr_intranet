class Frontend::MenusController < ApplicationController
  def index
  end

  def menus
    data = []
    menus = General::Menu.all
    menus.each do |menu|
      data << {
        id: menu.id,
        title: menu.title,
        description: menu.description,
        css_class: menu.css_class,
        code: menu.code,
        priority: menu.priority,
        parent_id: menu.parent_id,
        link: menu.link
      }
    end
    respond_to do |format|
      format.json { render json: data }
      format.js      
    end
  end
end
