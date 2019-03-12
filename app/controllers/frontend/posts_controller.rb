module Frontend
  class PostsController < ApplicationController
    after_action :set_tracking, only: [:index, :show, :new]  
    
  def index
    page = params[:page]
    params[:category].present? ? posts = News::Post.where(post_type: params[:category]).page(page).per(10) : posts = News::Post.page(page).per(10)

    # posts = News::Post.posts_cached
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: post.id,
        title: post.title,
        main_image: post.main_image,
        user_name: post.cached_users_names,
        created_at: post.created_at.strftime("%d/%m/%Y %H:%M"),
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
        format: post.format
      }
    end
    respond_to do |format|
      format.json { render json: {hits: data} }
      format.js
    end
  end

  def important_posts
    posts = News::Post.includes(:main_image).important
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? url_for(post.main_image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: post.id,
        title: post.title,
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
    data << {
      id: post.id,
      title: post.title,
      main_image: post.main_image,
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
        ]

    }
    respond_to do |format|
      format.json { render json: data[0] }
      format.js
    end    
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @post }
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