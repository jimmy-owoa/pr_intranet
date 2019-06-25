module Frontend
  class SearchController < FrontendController
    include Rails.application.routes.url_helpers

    def search_vue
      data = []
      users = []
      posts = []
      search = params[:term].present? ? params[:term] : nil
      if search
        # result = General::User.search search, fields: [:name], match: :word
        result = Searchkick.search(search, index_name: [General::User, General::Menu, News::Post], operator: "and", order: { _score: :desc })
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact.each do |user|
          users << {
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            annexed: user.annexed,
            birthday: user.birthday,
            image: user.image.attached? ?
            url_for(user.image) : root_url + '/assets/default_avatar.png'
          }
        end
        result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact.each do |post|
          @image = post.main_image.present? ? url_for(post.main_image.path) : nil
          posts << {
            id: post.id,
            status: post.status,
            title: post.title,
            slug: post.slug,
            content: post.content,
            published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y") : '',
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
        result = General::Menu.search search, fields: [:title, :link], match: :word
        result.with_hit.map{|a| a[0] if a[0].parent_id != nil && a[1]["_type"] == "general/menu"}.compact.each do |m|
          items <<
            {
              name: m.title,
              link: m.link
            }
        end
        data = items
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

  end
end