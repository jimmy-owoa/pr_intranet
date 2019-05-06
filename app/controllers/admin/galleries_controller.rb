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
    respond_to do |format|
      if @gallery.save
        @galleries_list = General::Gallery.all.map{|a| [a.id, a.name]}
        format.html { redirect_to edit_admin_gallery_path(@gallery), notice: 'Gallery was successfully created.' }
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
    respond_to do |format|
      if @gallery.update(gallery_params)
        format.html { redirect_to admin_gallery_path(@gallery), notice: 'Gallery was successfully updated.' }
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
      format.html { redirect_to admin_galleries_path, notice: 'Gallery was successfully destroyed.' }
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
      params.require(:gallery).permit(:name, :description, :date, attachment_ids: [] )
    end
  end
end
