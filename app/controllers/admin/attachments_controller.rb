module Admin
  class AttachmentsController < ApplicationController
    before_action :set_attachment, only: [:show, :edit, :update, :destroy]
    before_action :set_post, only: [:create, :new]
    layout 'admin'

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
      @attachment = General::Attachment.new(attachment_params)
      respond_to do |format|
        @attachment.path = rails_blob_url(@attachment.attachment, only_path: true)
        if @attachment.save
          @attachments_list = General::Attachment.all.map{|a| [a.id,a.name]}
          format.html { redirect_to edit_admin_attachment_path(@attachment), notice: 'Attachment was successfully created.'}
          format.json { render :show, status: :created, location: @attachment}
          format.js
        else
          format.html {render :new}
          format.json {render json: @attachment.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @attachment.update(attachment_params)
          format.html { redirect_to admin_attachment_path(@attachment), notice: 'Attachment was successfully updated.'}
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
        format.html { redirect_to admin_attachments_path, notice: 'Attachment was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = General::Attachment.find(params[:id])
    end

    def set_post
      if params[:post_id].present?
        @post = News::Post.find params[:post_id]
      end
    end

    def attachment_params
      params.require(:attachment).permit(:name, :path, :dimension, :is_public, :created_at, :updated_at, :attachment)
    end

  end
end
