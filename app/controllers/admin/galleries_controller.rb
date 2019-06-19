module Admin
  class GalleriesController < AdminController

  before_action :set_gallery, only: [:show, :edit, :update, :destroy]
  before_action :set_post, only: [:create, :new]

  def index
    add_breadcrumb "Galerías", :admin_galleries_path
    @galleries = General::Gallery.order(id: :desc).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json { render json: @galleries }
      format.js
    end
  end

  def show
    add_breadcrumb "Galerías", :admin_galleries_path
  end

  def new
    add_breadcrumb "Galerías", :admin_galleries_path
    @gallery = General::Gallery.new
    @attachments =  @gallery.attachments.build 
    respond_to do |format|
      format.html
      format.json { render json: @gallery }
      format.js
    end
  end

  def edit
    add_breadcrumb "Galerías", :admin_galleries_path
  end

  def create
    @gallery = General::Gallery.new(gallery_params)
    attachments_attributes = params[:attachments_attributes]
    images = attachments_attributes.present? ? attachments_attributes.keys.map(&:to_i) : []
    respond_to do |format|
      if @gallery.save
        if images.present? 
          images.each do |image|
            @gallery.attachments << General::Attachment.find(image)
          end
        end
        @galleries_list = General::Gallery.all.map{|a| [a.id, a.name]}
        format.html { redirect_to edit_admin_gallery_path(@gallery), notice: 'Galería fue creada con éxito.' }
        format.json { render :show, status: :created, location: @gallery }
        format.js
      else
        format.html { render :new }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    attachments_attributes = params[:attachments_attributes]
    images = attachments_attributes.present? ? attachments_attributes.keys.map(&:to_i) : []
    respond_to do |format|
      if @gallery.update(gallery_params)
        if images.present? 
          images.each do |image|
            @gallery.attachments << General::Attachment.find(image)
          end
        end
        format.html { redirect_to admin_gallery_path(@gallery), notice: 'Galería fue actualizada con éxito.' }
        format.json { render :show, status: :ok, location: @gallery }
      else
        format.html { render :edit }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gallery.destroy
    respond_to do |format|
      format.html { redirect_to admin_galleries_path, notice: 'Galería fue eliminada con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def set_gallery
      @gallery = General::Gallery.find(params[:id])
    end

    def set_post
      if params[:post_id].present?
        @post = News::Post.find params[:post_id]
      end
    end
    def gallery_params
      params.require(:gallery).permit(:name, :description, :date, :post_id, attachment_ids: [] )
    end
  end
end
