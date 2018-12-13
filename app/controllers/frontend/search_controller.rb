module Frontend
  class SearchController < ApplicationController

    def search
      search = params[:term].present? ? params[:term] : nil
      users = []
      posts = []
      users = []
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu]
        @users = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact
        @posts = result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact
        @menus = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact
      else
        @users = General::User.all
        @posts = News::Post.all
        @menus = General::Menu.all
      end
    end

    def search_vue
      data = []
      users = []
      search = params[:term].present? ? params[:term] : nil
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu]
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact.each do |user|
          users << {
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            annexed: user.annexed,
            birthday: user.birthday,
            image: @ip.to_s + Rails.application.routes.url_helpers.rails_blob_path(user.image, only_path: true)
          }
        end
        @posts = result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact
        @menus = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact
        data << [users, @posts, @menus]
      else
        data << { message: 'Ingresar parametro de busqueda' }
      end
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end      
    end
  end
end