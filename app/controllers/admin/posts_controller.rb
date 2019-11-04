module Admin
  class PostsController < AdminController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json
    before_action :set_categories, only: [:edit, :new]
    before_action :set_attachments, only: [:edit, :new]

    def index
      @posts = News::Post.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
        format.html
        format.json { render json: @posts }
        format.js
      end
    end

    def show
      @gallery = General::Gallery.where(post_id: @post.id).last
    end

    def deleted
      @posts_deleted = News::Post.only_deleted
    end

    def new
      @post = News::Post.new
      @attachment = General::Attachment.new
      @files = General::File.all
      @post.build_main_image
      @post.terms.build
      # @post.files.build
    end

    def edit
      @files = General::File.all
    end

    def create
      @post = News::Post.new(post_params)
      respond_to do |format|
        if @post.save
          set_tags
          set_files
          format.html { redirect_to admin_post_path(@post), notice: "Noticia fue creada con éxito." }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      params[:post][:published_at] = Time.parse(params[:post][:published_at]) if params[:post][:published_at].present?
      respond_to do |format|
        if @post.update(post_params)
          set_tags
          set_files
          format.html { redirect_to admin_post_path(@post), notice: "Noticia fue actualizada con éxito." }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @post.destroy
      respond_to do |format|
        format.html { redirect_to admin_posts_path, notice: "Noticia fue eliminada con éxito." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = News::Post.find(params[:id])
    end

    def set_categories
      @full_categories = General::Term.categories
      @user_categories = current_user.terms.categories
      if current_user.has_role? :super_admin
        @categories = @full_categories
      else
        @categories = @user_categories & @full_categories
      end
    end

    def set_galleries
      @galleries = General::Gallery
    end

    def set_attachments
      @attachments = General::Attachment
    end

    def post_params
      params.require(:post).permit(:title, :slug, :content, :status,
                                   :main_image_id, :main_image, :terms, :post_parent_id, :visibility, :post_class, :post_order,
                                   :published_at, :user_id, :post_type, :format, :permission, :important, :extract, :profile_id,
                                   gallery_ids: [], term_ids: [], terms_names: [], file_ids: [],
                                   main_image_attributes: [:attachment], general_attachment_attributes: [:general_attachment])
    end

    # SEGUIR CON SUBIR ARCHIVOS DESDE EL FORMULARIO DEL POST
    def set_files
      file_ids = params[:file_ids]
      if file_ids.present?
        # @post.file_ids << file_ids
      end
    end

    def set_tags
      # Getting terms_names from the form (tags)
      term_names = params[:terms_names]
      terms = []
      if term_names.present?
        term_names.uniq.each do |tag|
          terms << General::Term.where(name: tag, term_type: General::TermType.tag).first_or_create
        end
        @post.terms << terms
      end
    end
  end
end
