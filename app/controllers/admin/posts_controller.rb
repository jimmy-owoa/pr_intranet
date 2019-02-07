module Admin
  class PostsController < ApplicationController
    layout 'admin'
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json
    before_action :set_categories, only: [:edit, :new]
    before_action :set_attachments, only: [:edit, :new]

    layout 'admin'

    def index
      add_breadcrumb "Noticias", :admin_posts_path
      @posts = News::Post.paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
        format.html
        format.json { render json: @posts }
        format.js
      end
    end

    def show
      add_breadcrumb "Noticias", :admin_posts_path
    end

    def deleted
      @posts_deleted = News::Post.only_deleted
    end

    def new
      add_breadcrumb "Noticias", :admin_posts_path
      @post = News::Post.new
      @post.terms.build
    end

    def edit
      add_breadcrumb "Noticias", :admin_posts_path
    end

    def create
      params[:post][:published_at] = Time.parse(params[:post][:published_at]) if params[:post][:published_at].present?
      @post = News::Post.new(post_params)
      respond_to do |format|
        if @post.save
          params[:post][:gallery_ids].reject(&:blank?).each do |gallery_id|
            @post.galleries << General::Gallery.find(gallery_id)
          end
          set_tags
          format.html { redirect_to admin_post_path(@post), notice: 'Post was successfully created.'}
          format.json { render :show, status: :created, location: @post}
        else
          format.html {render :new}
          format.json {render json: @post.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      params[:post][:published_at] = Time.parse(params[:post][:published_at]) if params[:post][:published_at].present?
      respond_to do |format|
        if @post.update(post_params)
          params[:post][:gallery_ids].reject(&:blank?).each do |gallery_id|
            @post.galleries << General::Gallery.find(gallery_id)
          end
          set_tags
          format.html { redirect_to admin_post_path(@post), notice: 'Post was successfully updated.'}
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit}
          format.json { render json: @post.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @post.destroy
      respond_to do |format|
        format.html { redirect_to admin_posts_path, notice: 'Post was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end

    def set_categories
      @categories = General::Term.categories
    end

    def set_galleries
      @galleries = General::Gallery
    end
    def set_attachments
      @attachments = General::Attachment
    end

    def post_params
      params.require(:post).permit(:title, :slug, :content, :status,
      :main_image_id, :terms, :post_parent_id, :visibility, :post_class, :post_order, :published_at, :user_id, :post_type, :important, gallery_ids: [], terms_id: [])
    end

    def set_tags
      # Getting terms_names from the form (tags)
      tags = params[:terms_names]
      # If in the form the user doesnt add tags, this will do nothing
      if tags.present?
        tags.uniq.each do |tag|
          @post.terms.find_or_create_by(name: tag, term_type: General::TermType.tag,)
        end
      end
    end
  end
end
