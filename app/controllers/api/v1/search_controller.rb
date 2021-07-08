module Api::V1
  class SearchController < ApiController
    include Rails.application.routes.url_helpers
    skip_before_action :get_user, only: [:search_menu]

    def search_vue
      users = []
      posts = []
      menus = []
      search = params[:term].present? ? params[:term] : nil
      if search && search.length > 2
        # result = General::User.search search, fields: [:name], match: :word
        result = Searchkick.search(search, index_name: [General::User, General::Menu, News::Post], operator: "and", order: { _score: :desc })
        result.with_hit.map { |a| a[0] if a[1]["_index"][0...13] == "general_users" }.compact.each do |user|
          users << {
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            annexed: user.annexed,
            birthday: user.birthday,
            image: user.image.attached? ?
              url_for(user.image) : ActionController::Base.helpers.asset_path("default_avatar.png"),
          }
        end
        filtered_posts = filter_results_posts(result.with_hit.map { |a| a[0] if a[1]["_index"][0...10] == "news_posts" }.compact.sort_by { |post| post[:published_at] }.reverse)
        filtered_posts.each do |post|
          @image = post.main_image.present? ? url_for(post.main_image.path) : nil
          posts << {
            id: post.id,
            status: post.status,
            title: post.title,
            slug: post.slug,
            content: post.content,
            published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y") : "",
            terms: post.term_id,
            parent: post.post_parent_id,
            visibility: post.visibility,
            post_class: post.post_class,
            post_order: post.post_order,
            user: post.user_id,
            main_image: @image,
          }
        end
        menus_result = result.with_hit.map { |a| a[0] if a[1]["_index"][0...13] == "general_menus" }.compact
        menus_result.each do |menu|
          menus << menu if menu.link.present?
        end
        data = {users: users, posts: posts, menus: menus}
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def search_menu
      items = []
      data = {}
      search = params[:term].present? ? params[:term] : nil
      if search.present?
        result = General::Menu.search search, fields: [:title, :link], match: :word
        result.with_hit.map { |a| a[0] if a[1]["_index"].include?("general_menus") }.compact.each do |m|
          items <<
            {
              name: m.title,
              link: m.link,
            }
        end
        data = items
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    private

    def filter_results_posts(posts_array)
      ids = posts_array.pluck(:id)
      News::Post.where(id: ids).filter_posts(@request_user)
    end
  end
end
