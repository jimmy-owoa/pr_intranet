module Api::V1
  class PostsController < ApiController
    include ApplicationHelper

    def index
      category = params[:category]
      page = params[:page] || 1
    
      user_posts = News::Post.filter_posts(@request_user).normal_posts
      posts = category.present? ? user_posts.where(post_type: category) : user_posts
      posts = posts.page(page).per(10)

      data = ActiveModel::Serializer::CollectionSerializer.new(posts, serializer: PostSerializer)

      render json: { 
        data: data,
        size: posts.size,
        total_pages: posts.total_pages, 
        total_count: posts.total_count 
      }, status: :ok
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
      data = { status: "ok", page: params[:page] || 1, results_length: data_posts.count, articles: data_posts }
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

        data_post = {
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

        breadcrumbs = [
          { href: "/", text: "Inicio" },
          { href: "/momentos", text: "Momentos" },
          { href: "#", text: post.title.truncate(30), disabled: true },
        ]
        data = { status: "ok", article: data_post, relationed_posts: data_relationed_posts, breadcrumbs: breadcrumbs }
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
      posts = News::Post.filter_posts(@request_user).important_posts.first(5)
      data = ActiveModel::Serializer::CollectionSerializer.new(posts, serializer: PostSerializer)

      render json: { data: data, success: true }, status: :ok
    end

    def post
      slug = params[:slug].present? ? params[:slug] : nil
      post = News::Post.find_by_slug(slug)
      # data = ActiveModelSerializers::SerializableResource.new(post, serializer: PostSerializer, show_action: true)
      render json: post, serializer: PostSerializer, show_action: true
    end

    def last_posts
      posts = News::Post.normal_posts.published_posts.order(published_at: :desc).last(5)
      data_articles = []
      posts.each do |post|
        post_image = post.main_image.present? ? url_for(post.main_image.attachment.variant(resize: "100x100")) : root_url + "/assets/news.jpg"
        extract = post.extract.slice(0..104) rescue post.extract
        data_articles << {
          id: post.id,
          title: post.title.length > 43 ? post.title.slice(0..43) + "..." : post.title,
          published_at: post.published_at.strftime("%d/%m/%Y"),
          post_type: post.post_type.present? ? post.post_type.upcase : "",
          slug: post.slug,
          extract: extract,
          main_image: post_image,
        }
      end
      data = { status: "ok", results_length: posts.count, articles: data_articles }
      render json: data, status: :ok
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end
  end
end
