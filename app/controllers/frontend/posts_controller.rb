module Frontend
  class PostsController < FrontendController
    after_action :set_tracking, only: [:index, :show, :new]

    def index
      user_posts = News::Post.filter_posts(@request_user)
      page = params[:page]
      params[:category].present? ? posts = Kaminari.paginate_array(user_posts.select { |post| post.post_type == params[:category] }).page(page).per(4) :
        posts = Kaminari.paginate_array(user_posts).page(page).per(4)
      data = []
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + "/assets/news.jpg"
        data << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          full_title: post.title,
          published_at: post.created_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          important: post.important,
          tags: post.cached_tags,
          slug: post.slug,
          extract: post.extract.length > 104 ? post.extract.slice(0..104) + "..." : post.extract,
          breadcrumbs: [
            { link: "/", name: "Inicio" },
            { link: "/noticias", name: "Noticias" },
            { link: "#", name: post.title.truncate(30) },
          ],
          main_image: @image,
          format: post.format,
        }
      end
      respond_to do |format|
        format.json { render json: { hits: data } }
        format.js
      end
    end

    def gallery
      post_id = params[:post_id]
      post = News::Post.find(post_id)
      page = params[:page]
      gallery = { items: [] }
      items = []
      if post.gallery.present?
        attachments = General::Gallery.where(post_id: post.id).last.attachments
        attachments.each do |image| # Por ahora está mostrando sólo la primera galería
          items << {
            id: image.id,
            src: url_for(image.attachment),
            w: image.attachment.blob.metadata[:width],
            h: image.attachment.blob.metadata[:height],
            title: image.name,
            placeolder: url_for(image.attachment.variant(resize: "80x>")),
          }
        end
        gallery[:items] << items
      end
      respond_to do |format|
        format.json { render json: { hits: items } }
        format.js
      end
    end

    def important_posts
      posts = News::Post.filter_posts(@request_user, true).first(5)
      data = []
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "800x")) : root_url + "/assets/news.jpg"
        data << {
          id: post.id,
          title: post.title,
          user_id: General::User.find(post.user_id).name,
          published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
          content: post.content,
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          important: post.important,
          slug: post.slug,
          breadcrumbs: [
            { link: "/", name: "Inicio" },
            { link: "/noticias", name: "Noticias" },
            { link: "#", name: post.title.truncate(30) },
          ],
          main_image: @image,
          format: post.format,
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def fix_content(content)
      content = content.gsub("video controls=\"controls\"", "source")
      if Rails.env.development?
        content = content.gsub("<source src=\"../..", '<video src="http://localhost:3000')
        content = content.gsub("<source src=\"", '<video src="http://localhost:3000/')
        content = content.gsub("<img src=\"../..", '<img src="http://localhost:3000')
        content = content.gsub("<img src=\"/rails/", '<img src="http://localhost:3000/rails/')
        content = content.gsub("<a href=\"//rails/", '<a href="http://localhost:3000/rails/')
        content = content.gsub("<a href=\"/rails/", '<a href="http://localhost:3000/rails/')
        #video
        if content.include?("<p><video style=\"float: right;\"")
          content = content.gsub("<p><video style=\"float: right;\"", '<p align="right"><source style="float: right;"')
        end
        if content.include?("<p><video style=\"float: left;\"")
          content = content.gsub("<p><video style=\"float: left;\"", '<p align="left"><source style="float: left;"')
        end
        if content.include?("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"")
          content = content.gsub("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"", '<p align="center"><source style="display: block; margin-left: auto; margin-right: auto;"')
        end
        #image
        if content.include?("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\"")
          content = content.gsub("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"../..", '<p><img style="display: block; margin-left: auto; margin-right: auto;" src="http://localhost:3000')
        end
        if content.include?("<p><img style=\"float: right;\"")
          content = content.gsub("<p><img style=\"float: right;\" src=\"../..", '<p align="right"><img src="http://localhost:3000')
        end
        if content.include?("<p><img style=\"float: left;\"")
          content = content.gsub("<p><img style=\"float: left;\" src=\"../..", '<p align="left"><img src="http://localhost:3000')
        end
      else
        content = content.gsub("<source src=\"../..", '<video src="https://app.elmejorlugarparatrabajar.cl')
        content = content.gsub("<source src=\"", '<video src="https://app.elmejorlugarparatrabajar.cl/')
        content = content.gsub("<img src=\"../..", '<img src="https://app.elmejorlugarparatrabajar.cl')
        content = content.gsub("<img src=\"/rails/", '<img src="https://app.elmejorlugarparatrabajar.cl/rails/')
        content = content.gsub("<a href=\"//rails/", '<a href="https://app.elmejorlugarparatrabajar.cl/rails/')
        content = content.gsub("<a href=\"/rails/", '<a href="https://app.elmejorlugarparatrabajar.cl/rails/')

        #video
        if content.include?("<p><video style=\"float: right;\"")
          content = content.gsub("<p><video style=\"float: right;\"", '<p align="right"><source style="float: right;"')
        end
        if content.include?("<p><video style=\"float: left;\"")
          content = content.gsub("<p><video style=\"float: left;\"", '<p align="left"><source style="float: left;"')
        end
        if content.include?("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"")
          content = content.gsub("<p><video style=\"display: block; margin-left: auto; margin-right: auto;\"", '<p align="center"><source style="display: block; margin-left: auto; margin-right: auto;"')
        end
        #image
        if content.include?("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\"")
          content = content.gsub("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"../..", '<p><img style="display: block; margin-left: auto; margin-right: auto;" src="https://app.elmejorlugarparatrabajar.cl')
        end
        if content.include?("<p><img style=\"float: right;\"")
          content = content.gsub("<p><img style=\"float: right;\" src=\"../..", '<p align="right"><img src="https://app.elmejorlugarparatrabajar.cl')
        end
        if content.include?("<p><img style=\"float: left;\"")
          content = content.gsub("<p><img style=\"float: left;\" src=\"../..", '<p align="left"><img src="https://app.elmejorlugarparatrabajar.cl')
        end
      end
      content = content.gsub("/></video>", ' width="600" height="350" controls=\"controls\" /></video>')
    end

    def post
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      if post.profile_id.in?(@request_user.profile_ids)
        relationed_posts = News::Post.where(post_type: post.post_type).filter_posts(@request_user).last(5) - [post]
        data_relationed_posts = []
        relationed_posts.each do |post|
          data_relationed_posts << {
            id: post.id,
            title: post.title.length > 36 ? post.title.slice(0..36) + "..." : post.title,
            slug: post.slug,
            extract: post.extract.present? && post.extract.length > 36 ? post.extract.slice(0..36) + "..." : post.extract,
            published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
            main_image: post.main_image.present? ? url_for(post.main_image.attachment) : root_url + "/assets/news.jpg",
          }
        end
        content = fix_content(post.content)
        data << {
          id: post.id,
          title: post.title,
          url: root_url + "admin/posts/" + "#{post.id}" + "/edit",
          user_id: post.user_id,
          published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
          content: content,
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          important: post.important,
          tags: post.terms.tags,
          main_image: post.main_image.present? ? url_for(post.main_image.attachment) : root_url + "/assets/news.jpg",
          format: post.format,
          extract: post.extract.present? ? post.extract : "",
          breadcrumbs: [
            { link: "/", name: "Inicio" },
            { link: "/noticias", name: "Noticias" },
            { link: "#", name: post.title.truncate(30) },
          ],
          relationed_posts: data_relationed_posts,
        }
        respond_to do |format|
          format.json { render json: data[0] }
          format.js
        end
      else
        respond_to do |format|
          format.json { render json: "No tiene acceso" }
          format.js
        end
      end
    end

    private

    def set_tracking
      ahoy.track "Post Model", params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end
  end
end
