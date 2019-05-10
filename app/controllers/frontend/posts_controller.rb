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
        published_at: post.created_at.strftime("%d/%m/%Y · %H:%M"),
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
        title: post.title.capitalize,
        main_image: post.main_image,
        user_id: General::User.find(post.user_id).name,
        published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
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
        format: post.format,
        gallery: gallery,
      }
    end
    respond_to do |format|
      format.json { render json: data }
      format.js
    end
  end

  def fix_content content
    content = content.gsub("video controls=\"controls\"", 'source')
    if Rails.env.development?
      content = content.gsub("<source src=\"../..", '<video src="http://localhost:3000')
      content = content.gsub("<source src=\"", '<video src="')
      content = content.gsub("<img src=\"../..", '<img src="http://localhost:3000')
      content = content.gsub("<img src=\"rails/", '<img src="http://localhost:3000/rails/')
    else
      content = content.gsub("<source src=\"../..", '<video src="http://intranet-security-qa-v1.s3-website.us-east-2.amazonaws.com')
      content = content.gsub("<source src=\"", '<video src="')
      content = content.gsub("<img src=\"../..", '<img src="http://intranet-security-qa-v1.s3-website.us-east-2.amazonaws.com')
      content = content.gsub("<img src=\"rails/", '<img src="http://intranet-security-qa-v1.s3-website.us-east-2.amazonaws.com/rails/')
    end
    content = content.gsub("/></video>", ' width="600" height="350" controls=\"controls\" /></video>')
  end

  def post
    data = []
    slug = params[:slug].present? ? params[:slug] : nil
    post = News::Post.find_by_slug(slug)
    relationed_posts = News::Post.where(post_type: post.post_type).last(5) - [post]
    data_relationed_posts = []
    relationed_posts.each do |post|
      data_relationed_posts << {
        id: post.id,
        title: post.title.capitalize.slice(0..52) + '...',
        slug: post.slug,
        published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
        main_image: post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      }
    end
    image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
    gallery = []
    content = fix_content(post.content)
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
      title: post.title.capitalize,
      main_image: post.main_image,
      url: root_url + 'admin/posts/' + "#{post.id}" + '/edit',
      user_id: General::User.find(post.user_id).name,
      published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
      content: content,
      post_type: post.post_type.upcase,
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
      gallery: gallery,
      relationed_posts: data_relationed_posts
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