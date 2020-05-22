module Admin
  class AttachmentsController < AdminController
    # skip_before_action :authenticate_user!, :only => [:create, :upload]
    require "will_paginate/array"
    skip_before_action :verify_authenticity_token, only: [:create, :upload]
    before_action :set_attachment, only: [:show, :edit, :update, :destroy]
    before_action :set_post, only: [:create, :new]
    respond_to :json, :html

    def index
      @attachments = Media::Attachment.order(created_at: :desc).paginate(:page => params[:page], :per_page => 12)
    end

    def index_images
      @images = Media::Attachment.images.paginate(:page => params[:page], :per_page => 12)
    end

    def index_videos
      @videos = Media::Attachment.videos.paginate(:page => params[:page], :per_page => 12)
    end

    def upload
      if params[:file].present?
        new_attachment = Media::Attachment.new
        new_attachment.attachment.attach(params[:file])
        new_attachment.save
      end
      respond_to do |format|
        format.json { render json: { "location": url_for(new_attachment.attachment) }.to_json, status: :ok }
      end
    end

    def show
      add_breadcrumb "Medios", :admin_attachments_path
    end

    def new
      add_breadcrumb "Medios", :admin_attachments_path
      @image_list = Media::Attachment.paginate(:page => params[:page], :per_page => 12)
      @attachment = Media::Attachment.new
      respond_to do |format|
        format.html
        format.json { render json: @attachment }
        format.js
      end
    end

    def new_video
      @video_list = Media::Attachment.videos.paginate(:page => params[:page], :per_page => 10)
      @video = Media::Attachment.new
      respond_to do |format|
        format.json { render json: @video }
        format.js
      end
    end

    def edit
      add_breadcrumb "Medios", :admin_attachments_path
    end

    def create
      @attachment = Media::Attachment.create(attachment_params)
      set_tags
      respond_to do |f|
        f.json {
          render json: {
            attachment_id: @attachment.id,
          }
        }
        f.html {
          redirect_to :back
        }
      end
    end

    def update
      attch_name = params.dig("general_attachment", "name")
      if attch_name.blank?
        name = attachment_params[:name]
        caption = attachment_params[:caption]
        attachment = attachment_params[:attachment]
      end
      if attch_name.present?
        respond_to do |format|
          if @attachment.update_attributes(name: attch_name)
            format.json { head :ok }
          else
            format.json { respond_with_bip(@attachment) }
          end
        end
      else
        respond_to do |format|
          if name.present? || caption.present?
            @attachment.update(name: name, caption: caption)
            @attachment.update(attachment: attachment) if attachment.present?
            set_tags
            format.html { redirect_to admin_attachment_path(@attachment), notice: "Archivo fué correctamente actualizado." }
            format.json { render :show, status: :ok, location: @attachment }
          elsif @attachment.update(attachment_params)
            set_tags
            format.html { redirect_to admin_attachment_path(@attachment), notice: "Archivo fué correctamente actualizado." }
            format.json { render :show, status: :ok, location: @attachment }
          else
            format.html { render :edit }
            format.json { render json: @attachment.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    def destroy
      att_id = params[:id]
      gal_id = Media::Attachment.find(att_id).gallery_ids
      if gal_id.present?
        @attachment.destroy
        redirect_to edit_admin_gallery_path(gal_id)
      else
        @attachment.destroy
        respond_to do |format|
          format.html { redirect_to admin_attachments_path, notice: "Archivo fué correctamente eliminado." }
          format.json { head :no_content }
        end
      end
    end

    def search_att
      @search = Media::Attachment.where("name LIKE '%#{params[:search]}%' ").map { |i| { name: i.name, val: i.id, 'data-img-src': i } }.paginate(:page => params[:page], :per_page => 15)
      render json: { data: @search }
    end

    def search_video
      @search = Media::Attachment.where("name LIKE '%#{params[:search]}%' ").select { |e| e.attachment.video? }
      @search = @search.map { |i| { name: i.name, val: i.id, 'data-img-src': url_for(i.attachment.preview(resize: "x50")) } }.paginate(:page => params[:page], :per_page => 15)
      render json: { data: @search }
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Media::Attachment.find(params[:id])
    end

    def set_post
      if params[:post_id].present?
        @post = News::Post.find params[:post_id]
      end
    end

    def attachment_params
      if params["attachment"].present?
        if params["attachment"]["attachment"].kind_of?(Array)
          params["attachment"]["attachment"] = params["attachment"]["attachment"].first
        else
          params["attachment"]["attachment"] = params["attachment"]["attachment"]
        end
        params.require(:attachment).permit(:name, :path, :dimension, :is_public, :created_at, :updated_at, :attachment, :caption, term_ids: [])
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
