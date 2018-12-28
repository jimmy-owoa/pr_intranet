module Frontend
  class PostsController < ApplicationController
    after_action :set_tracking, only: [:index, :show, :new]  

  def index
    posts = News::Post.includes(:main_image)
    data = []
    posts.each do |post|
      @image = post.main_image.present? ? @ip + post.main_image.path : nil
      data << {
        id: post.id,
        title: post.title,
        main_image: post.main_image,
        user_id: General::User.find(post.user_id).name,
        created_at: post.created_at.strftime("%d/%m/%Y %H:%M"),
        content: post.content,
        indicators: IndicatorService.perform[:santoral]['hoy'],
        main_image: @image
      }
    end
    respond_to do |format|
      format.json { render json: data }
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