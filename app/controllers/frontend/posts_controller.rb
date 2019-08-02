module Frontend
  class PostsController < FrontendController
    after_action :set_tracking, only: [:index, :show, :new]

  def index
    user_posts = News::Post.filter_posts(params[:ln_user])
    page = params[:page]
    params[:category].present? ? posts = Kaminari.paginate_array(user_posts.select{|post| post.post_type == params[:category]}).page(page).per(4) :
    posts = Kaminari.paginate_array(user_posts).page(page).per(4)
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: post.id,
        title: post.title,
        main_image: post.main_image,
        published_at: post.created_at.strftime("%d/%m/%Y · %H:%M"),
        post_type: post.post_type.present? ? post.post_type.upcase : '',
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
        format: post.format
      }
    end
    respond_to do |format|
      format.json { render json: {hits: data} }
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
      attachments = post.gallery.attachments
      attachments.each do |image| # Por ahora está mostrando sólo la primera galería
        items << {
          id: image.id,
          src: url_for(image.attachment),
          w: image.attachment.blob.metadata[:width],
          h: image.attachment.blob.metadata[:height],
          title: image.name,
          placeolder: url_for(image.attachment.variant(resize: "80x>"))
        }
      end
      gallery[:items] << items
    end
    respond_to do |format|
      format.json { render json: {hits: items} }
      format.js
    end
  end

  def important_posts
    posts = News::Post.filter_posts(params[:ln_user], true).first(5)
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'        
      data << {
        id: post.id,
        title: post.title,
        main_image: post.main_image,
        user_id: General::User.find(post.user_id).name,
        published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
        content: post.content,
        post_type: post.post_type.present? ? post.post_type.upcase : '',
        important: post.important,
        slug: post.slug,
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/noticias', name: 'Noticias'},
          {link: '#', name: post.title.truncate(30)}
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

  def fix_content content
    content = content.gsub("video controls=\"controls\"", 'source')
    if Rails.env.development?
      content = content.gsub("<source src=\"../..", '<video src="http://192.168.1.70:3000')
      content = content.gsub("<source src=\"", '<video src="http://192.168.1.70:3000/')
      content = content.gsub("<img src=\"../..", '<img src="http://192.168.1.70:3000')
      content = content.gsub("<img src=\"rails/", '<img src="http://192.168.1.70:3000/')
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
        content = content.gsub("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"../..", '<p><img style="display: block; margin-left: auto; margin-right: auto;" src="http://192.168.1.70:3000')
      end
      if content.include?("<p><img style=\"float: right;\"")
        content = content.gsub("<p><img style=\"float: right;\" src=\"../..", '<p align="right"><img src="http://192.168.1.70:3000')
      end
      if content.include?("<p><img style=\"float: left;\"")
        content = content.gsub("<p><img style=\"float: left;\" src=\"../..", '<p align="left"><img src="http://192.168.1.70:3000')
      end
    else
      content = content.gsub("<source src=\"../..", '<video src="https://admin.elmejorlugarparatrabajar.cl')
      content = content.gsub("<source src=\"", '<video src="https://admin.elmejorlugarparatrabajar.cl/')
      content = content.gsub("<img src=\"../..", '<img src="https://admin.elmejorlugarparatrabajar.cl')
      content = content.gsub("<img src=\"rails/", '<img src="https://admin.elmejorlugarparatrabajar.cl/')
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
        content = content.gsub("<p><img style=\"display: block; margin-left: auto; margin-right: auto;\" src=\"../..", '<p><img style="display: block; margin-left: auto; margin-right: auto;" src="https://admin.elmejorlugarparatrabajar.cl')
      end
      if content.include?("<p><img style=\"float: right;\"")
        content = content.gsub("<p><img style=\"float: right;\" src=\"../..", '<p align="right"><img src="https://admin.elmejorlugarparatrabajar.cl')
      end
      if content.include?("<p><img style=\"float: left;\"")
        content = content.gsub("<p><img style=\"float: left;\" src=\"../..", '<p align="left"><img src="https://admin.elmejorlugarparatrabajar.cl')
      end
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
        title: post.title.slice(0..52) + '...',
        slug: post.slug,
        published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
        main_image: post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      }
    end
    image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'

    content = fix_content(post.content)
    data << {
      id: post.id,
      title: post.title,
      main_image: post.main_image,
      url: root_url + 'admin/posts/' + "#{post.id}" + '/edit',
      user_id: General::User.find(post.user_id).name,
      published_at: post.published_at.present? ? post.published_at.strftime("%d/%m/%Y · %H:%M") : post.created_at.strftime("%d/%m/%Y · %H:%M"),
      content: content,
      post_type: post.post_type.present? ? post.post_type.upcase : '',
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