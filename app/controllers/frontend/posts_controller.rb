module Frontend
  class PostsController < FrontendController
    include ApplicationHelper
    def index
      user_posts = @request_user.has_role?(:admin) ? News::Post.all.order(published_at: :desc) : News::Post.normal_posts.filter_posts(@request_user)
      page = params[:page]
      params[:category].present? ? posts = Kaminari.paginate_array(user_posts.select { |post| post.post_type == params[:category] }).page(page).per(4) :
        posts = Kaminari.paginate_array(user_posts).page(page).per(4)
      data = []
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + "/assets/news.jpg"
        extract = post.extract.slice(0..104) rescue post.extract
        data << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          full_title: post.title,
          published_at: post.created_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          important: post.important,
          slug: post.slug,
          extract: extract,
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

    def index_video
      user_posts = @request_user.has_role?(:admin) ? News::Post.all.order(published_at: :desc) : News::Post.normal_posts.filter_posts(@request_user)
      page = params[:page]

      if params[:category].present?
        if params[:category] == "Videos"
          posts = Kaminari.paginate_array(user_posts.select { |post| post.post_type == "Video" }).page(page).per(4)
        elsif params[:category] == "Fotos"
          posts = Kaminari.paginate_array(user_posts.select { |post| post.gallery.present? }).page(page).per(4)
        else
          posts_video = user_posts.select { |post| post.post_type == "Video" }
          posts_gallery = user_posts.select { |post| post.gallery.present? }
          posts = posts_video+posts_gallery
          posts = Kaminari.paginate_array(posts.sort_by{ |e| e[:created_at] }.reverse).page(page).per(4) 
        end
      else
        posts_video = user_posts.select { |post| post.post_type == "Video" }
        posts_gallery = user_posts.select { |post| post.gallery.present? }
        posts = posts_video+posts_gallery
        posts = Kaminari.paginate_array(posts.sort_by{ |e| e[:created_at] }.reverse).page(page).per(4)  
      end
      
      data = []
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + "/assets/news.jpg"
        @video = post.file_video.present? ? url_for(post.file_video.attachment) : root_url + "/assets/news.jpg"
        extract = post.extract.slice(0..104) rescue post.extract
        data << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          full_title: post.title,
          published_at: post.created_at.strftime("%d/%m/%Y"),
          slug: post.slug,
          extract: extract,
          breadcrumbs: [
            { link: "/", name: "Inicio" },
            { link: "/momentos-security", name: "momentos-security" },
            { link: "#", name: post.title.truncate(30) },
          ],
          main_image: @image,
          file_video: @video,
          format: post.format,
        }
      end
      respond_to do |format|
        format.json { render json: { hits: data } }
        format.js
      end
    end

    def post_video
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      if @request_user.has_role?(:admin) || post.profile_id.in?(@request_user.profile_ids)
        relationed_posts = post.get_relationed_posts(@request_user)

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
            { link: "/momentos-security", name: "Momentos" },
            { link: "#", name: post.title.truncate(30) },
          ],
          file_video: post.file_video.present? ? url_for(post.file_video.attachment) : root_url + "/assets/news_video_image.jpg",
          relationed_posts: data_relationed_posts
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
      posts = @request_user.has_role?(:admin) ? News::Post.important.first(5) : News::Post.normal_posts.filter_posts(@request_user, true).first(5)
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

    def post
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      if @request_user.has_role?(:admin) || post.profile_id.in?(@request_user.profile_ids)
        relationed_posts = post.get_relationed_posts(@request_user)

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
          relationed_posts: data_relationed_posts
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

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end
  end
end
