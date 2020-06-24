module Api::V1
  class PostsController < ApiController
    include ApplicationHelper

    def index
      user_posts = News::Post.filter_posts(@request_user).normal_posts
      posts = params[:category].present? ? user_posts.where(post_type: params[:category]) : user_posts
      posts = posts.paginate(:page => params[:page], :per_page => 10)
      data_posts = [] 
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "900x600")) : root_url + "/assets/news.jpg"
        extract = post.extract.slice(0..104) rescue post.extract
        content = fix_content(post.content)
        data_posts << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          full_title: post.title,
          published_at: post.published_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          content: content,
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

      data = { status: "ok", page: params[:page] || 1, articles: data_posts, articles_length: data_posts.count }

      render json: data, status: :ok
    end

    def index_video
      posts = News::Post.filter_posts(@request_user).get_by_category(params[:category])
      posts = posts.paginate(:page => params[:page], :per_page => 10)
      data_posts = []
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "600x400")) : root_url + "/assets/news.jpg"
        @video = post.file_video.present? ? url_for(post.file_video.attachment) : @image
        extract = post.extract.slice(0..104) rescue post.extract
        data_posts << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          full_title: post.title,
          published_at: post.created_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          slug: post.slug,
          extract: extract,
          breadcrumbs: [
            { href: "/", text: "Inicio" },
            { href: "/momentos", text: "momentos" },
            { href: "#", text: post.title.truncate(30) },
          ],
          main_image: @image,
          file_video: @video,
          format: post.format,
        }
      end
      data = { status: "ok", page: params[:page] || 1, articles: data_posts, articles_length: data_posts.count }
      render json: data, status: :ok
    end

    def post_video
      data = []
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      if @request_user.has_role?(:admin) || @request_user.has_role?(:super_admin) || post.profile_id.in?(@request_user.profile_ids)
        relationed_posts = post.get_moments_relationed_posts(@request_user)
        data_relationed_posts = []
        relationed_posts.each do |post|
          data_relationed_posts << {
            id: post.id,
            title: post.title.length > 36 ? post.title.slice(0..36) + "..." : post.title,
            slug: post.slug,
            extract: post.extract.present? && post.extract.length > 36 ? post.extract.slice(0..36) + "..." : post.extract,
            published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
            main_image: post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "400x200")) : root_url + "/assets/news.jpg",
            post_type: post.post_type,
          }
        end
        content = fix_content(post.content)

        data = { status: "ok", article: {}, relationed_posts: data_relationed_posts, breadcrumbs: '' }
        data[:article] = {
          id: post.id,
          title: post.title,
          # url: root_url + "admin/posts/" + "#{post.id}" + "/edit",
          user_id: post.user_id,
          published_at: post.published_at.present? ? post.published_at.strftime("%d-%m-%Y") : post.created_at.strftime("%d-%m-%Y"),
          content: content,
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          main_image: post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "600x400")) : root_url + "/assets/news.jpg",
          format: post.format,
          extract: post.extract.present? ? post.extract : "",
          file_video: post.file_video.present? ? url_for(post.file_video.attachment) : '',
          status: post.status,
        }

        data[:breadcrumbs] = [
          { href: "/", text: "Inicio" },
          { href: "/momentos", text: "Momentos" },
          { href: "#", text: post.title.truncate(30), disabled: true },
        ]
        
        render json: data, status: :ok
      else
        render json: { status: "No tiene acceso" }
      end
    end

    def gallery
      post_id = params[:post_id]
      post = News::Post.find(post_id)
      page = params[:page]
      gallery = { items: [] }
      items = []
      if post.gallery.present?
        attachments = Media::Gallery.where(post_id: post.id).last.attachments
        attachments.each do |image| # Por ahora está mostrando sólo la primera galería
          if image.attachment.attached?
            items << {
              id: image.id,
              src: url_for(image.attachment.variant(resize: "900x>")),
              w: 900,
              h: 600,
              # w: image.attachment.blob.metadata[:width],
              # h: image.attachment.blob.metadata[:height],
              title: image.name,
              placeolder: url_for(image.attachment.variant(resize: "80x>")),
            }
          end
        end
        gallery[:items] << items
      end
      respond_to do |format|
        format.json { render json: { hits: items } }
        format.js
      end
    end

    def important_posts
      posts = News::Post.filter_posts(@request_user, true).normal_posts.first(5)

      data = { status: "ok", articles: [], articles_length: posts.count }
      posts.each do |post|
        @image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "1920x")) : root_url + "/assets/news.jpg"
        data[:articles] << {
          id: post.id,
          title: post.title,
          # user_id: General::User.find(post.user_id).name,
          published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
          content: post.content.present? ? post.content : "",
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
      
      render json: data, status: :ok
    end

    def post
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      if @request_user.has_role?(:admin) || @request_user.has_role?(:super_admin) || post.profile_id.in?(@request_user.profile_ids)
        relationed_posts = post.get_relationed_posts(@request_user)

        data_relationed_posts = []
        relationed_posts.each do |post|
          data_relationed_posts << {
            id: post.id,
            title: post.title,
            slug: post.slug,
            extract: post.extract.present? && post.extract.length > 36 ? post.extract.slice(0..36) + "..." : post.extract,
            published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
            main_image: post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "400x200")) : root_url + "/assets/news.jpg",
          }
        end
        content = fix_content(post.content)

        data = { status: "ok", article: {}, relationed_posts: data_relationed_posts, breadcrumbs: '' }
        data[:article] = {
          id: post.id,
          title: post.title,
          # url: root_url + "admin/posts/" + "#{post.id}" + "/edit",
          user_id: post.user_id,
          published_at: post.published_at.present? ? post.published_at.strftime("%d-%m-%Y") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
          content: content,
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          important: post.important,
          tags: post.terms.tags,
          main_image: post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "1000x800")) : root_url + "/assets/news.jpg",
          format: post.format,
          extract: post.extract.present? ? post.extract : "",
          status: post.status,
        }

        data[:breadcrumbs] = [
          { text: "Inicio", href: "/", disabled: false },
          { text: "Noticias", href: "/noticias", disabled: false },
          { text: post.title.truncate(34), href: "/", disabled: true },
        ]
        
        render json: data, status: :ok
      else
        render json: { status: "error", message: "No tiene accesso" }
      end
    end

    def last_posts
      posts = News::Post.normal_posts.published_posts.order(published_at: :desc).last(5)

      data = { status: "ok", articles: [], articles_length: posts.count }
      posts.each do |post|
        post_image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "100x100")) : root_url + "/assets/news.jpg"
        extract = post.extract.slice(0..104) rescue post.extract
        data[:articles] << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          published_at: post.published_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          slug: post.slug,
          extract: extract,
          main_image: post_image,
        }
      end

      render json: data, status: :ok
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end
  end
end