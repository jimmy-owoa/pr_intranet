module Frontend
  class SearchController < ApplicationController

    include Rails.application.routes.url_helpers

    def search_vue
      data = []
      users = []
      posts = []
      search = params[:term].present? ? params[:term] : nil
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu], match: :word
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact.each do |user|
          users << {
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            annexed: user.annexed,
            birthday: user.birthday,
            image: @ip.to_s + rails_blob_path(user.image, only_path: true)
          }
        end
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact.each do |post|
          @image = post.main_image.present? ? @ip + post.main_image.path : nil
          posts << {
            status: post.status,
            title: post.title,
            slug: post.slug,
            content: post.content,
            published_at: post.published_at,
            terms: post.term_id,
            parent: post.post_parent_id,
            visibility: post.visibility,
            post_class: post.post_class,
            post_order: post.post_order,
            user: post.user_id,
            main_image: @image
          }
        end
        @menus = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact
        data << [users, posts, @menus]
      else
        data << { message: 'Ingresar parametro de busqueda' }
      end
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end      
    end

    def search_menu
      items = []
      data = {}
      search = params[:term].present? ? params[:term] : nil

      if search.present?
        result = General::Menu.search search, fields: [:title, :link], match: :text_middle
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact.each do |m|
          items <<
            {              
              name: m.title,
              link: m.link
            }
        end
        data = items
      else
        data = { message: 'Ingresar parametro de busqueda' }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end      
    end

  end
end