module Admin
  class AttachmentsController < AdminController
    skip_before_action :authenticate_user!, :only => :create
    before_action :set_attachment, only: [:show, :edit, :update, :destroy]
    before_action :set_post, only: [:create, :new]
    before_action :set_terms, only: [:edit, :new]

    def index
      add_breadcrumb "Medios", :admin_attachments_path
      @attachments = General::Attachment.paginate(:page => params[:page], :per_page => 12)
      respond_to do |format|
        format.html
        format.json { render json: @attachments }
        format.js
      end
    end

    def upload
    end

    def show
      add_breadcrumb "Medios", :admin_attachments_path
    end

    def new
      add_breadcrumb "Medios", :admin_attachments_path
      @attachment = General::Attachment.new
      respond_to do |format|
      format.html
      format.json { render json: @attachment }
      format.js
    end
    end

    def edit
      add_breadcrumb "Medios", :admin_attachments_path
    end

    def create
      binding.pry
      @attachment = General::Attachment.create(attachment_params)
      set_tags
      respond_to do |f|
        f.json {
          render json: {
            attachment_id: @attachment.id
          }
        }
        f.html {
          redirect_to :back
        }
      end
    end

    def update
      respond_to do |format|
        if @attachment.update(attachment_params)
          set_tags
          format.html { redirect_to admin_attachment_path(@attachment), notice: 'Archivo fué correctamente actualizado.'}
          format.json { render :show, status: :ok, location: @attachment }
        else
          format.html { render :edit}
          format.json { render json: @attachment.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @attachment.destroy
      respond_to do |format|
        format.html { redirect_to admin_attachments_path, notice: 'Archivo fué correctamente eliminado.'}
        format.json { head :no_content }
      end
    end

    def search_att
      @search = General::Attachment.where("name LIKE '%#{params[:search]}%' ").map{|i| {name: i.name, val: i.id, 'data-img-src': url_for(i.thumb)}}
      render json: {data: @search}
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = General::Attachment.find(params[:id])
    end

    def set_terms
      full_categories = General::Term.categories
      inclusive_tags = General::Term.tags.inclusive_tags
      excluding_tags = General::Term.tags.excluding_tags
      user_categories = current_user.terms.categories
      if current_user.has_role? :super_admin
        @categories = full_categories
        @inclusive_tags = inclusive_tags
        @excluding_tags = excluding_tags 
      else
        @categories = @user_categories & @full_categories
      end
    end

    def set_post
      if params[:post_id].present?
        @post = News::Post.find params[:post_id]
      end
    end

    def attachment_params
      if params["attachment"]["attachment"].kind_of?(Array)
        params["attachment"]["attachment"] = params["attachment"]["attachment"].first
      else
        params["attachment"]["attachment"] = params["attachment"]["attachment"]
      end
      params.require(:attachment).permit(:name, :path, :dimension, :is_public, :created_at, :updated_at, :attachment, term_ids: [] )
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
