module Frontend
  class PostsController < FrontendController
    after_action :set_tracking, only: [:index, :show, :new]

  def index
    user_posts = filter_posts(params[:id])
    page = params[:page]
    params[:category].present? ? posts = Kaminari.paginate_array(user_posts.select{|post| post.post_type == params[:category]}).page(page).per(10) :
    posts = Kaminari.paginate_array(user_posts).page(page).per(10)
    data = []
    gallery = []
    posts.each do |post|
      if post.galleries.present?
        post.galleries.first.attachments.each do |image| # Por ahora está mostrando sólo la primera galería
          gallery << {
            id: image.id,
            url: url_for(image.attachment)
          }
        end
      end
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: post.id,
        title: post.title.capitalize,
        main_image: post.main_image,
        user_name: post.cached_users_names,
        published_at: post.created_at.strftime("%d/%m/%Y %H:%M"),
        content: post.content,
        post_type: post.post_type,
        important: post.important,
        tags: post.cached_tags,
        slug: post.slug,
        extract: post.extract,
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/noticias', name: 'Noticias'},
          {link: '#', name: post.title.truncate(30)}
        ],
        main_image: @image,
        format: post.format,
        gallery: gallery
      }
    end
    respond_to do |format|
      format.json { render json: {hits: data} }
      format.js
    end
  end

  def filter_posts id
    user = General::User.find(id)
    user_tags = user.terms.tags.map(&:name)
    posts = []
    News::Post.all.each do |post|
      post.terms.tags.each do |tag|
        posts.push(post) if tag.name.in?(user_tags)
      end
    end
    posts
  end

  def important_posts
    posts = News::Post.includes(:main_image).important
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: post.id,
        published_at: post.published_at,
        title: post.title.capitalize,
        main_image: post.main_image,
        user_id: General::User.find(post.user_id).name,
        created_at: post.created_at.strftime("%d/%m/%Y %H:%M"),
        content: post.content,
        post_type: post.post_type,
        important: post.important,
        slug: post.slug,
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/noticias', name: 'Noticias'},
          {link: '#', name: post.title.truncate(30)}
        ],
        main_image: @image,
        format: post.format
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
    image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
    gallery = []
      if post.galleries.present?
        post.galleries.first.attachments.each do |image| # Por ahora está mostrando sólo la primera galería
          gallery << {
            id: image.id,
            url: url_for(image.attachment)
          }
        end
      end
    data << {
      id: post.id,
      title: post.title,
      main_image: post.main_image,
      url: root_url + 'admin/posts/' + "#{post.id}" + '/edit',
      user_id: General::User.find(post.user_id).name,
      created_at: post.created_at.strftime("%d/%m/%Y %H:%M"),
      content: post.content,
      post_type: post.post_type,
      important: post.important,
      tags: post.terms.tags,
      main_image: image,
      format: post.format,
      extract: post.extract,
      breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/noticias', name: 'Noticias'},
          {link: '#', name: post.title.truncate(30)}
        ],
      gallery: gallery

    }
    respond_to do |format|
      format.json { render json: data[0] }
      format.js
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