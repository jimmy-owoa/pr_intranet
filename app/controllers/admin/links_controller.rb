module Admin
  class LinksController < ApplicationController
    layout 'admin'
    before_action :set_link, only: [:show, :edit, :update, :destroy]

    def index
      @links = General::Link.all
    end

    def show
      add_breadcrumb "Links", :admin_links_path
    end
    
    def new
      add_breadcrumb "Links", :admin_links_path
      @link = General::Link.new
    end

    def edit
      add_breadcrumb "Links", :admin_links_path
    end

    def create
      @link = General::Link.new(link_params)
      respond_to do |format|
        if @link.save
          format.html { redirect_to admin_link_path(@link), notice: 'Link was successfully created.'}
          format.json { render :show, status: :created, location: @link}
          format.js
        else
          format.html {render :new}
          format.json {render json: @link.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @link.update(link_params)
          format.html { redirect_to admin_link_path(@link), notice: 'Link was successfully updated.'}
          format.json { render :show, status: :ok, location: @link }
        else
          format.html { render :edit}
          format.json { render json: @link.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @link.destroy
      respond_to do |format|
        format.html { redirect_to admin_links_path, notice: 'Link was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private

    def set_link
      @link = General::Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:title, :url, :image)
    end
  end
end