module Admin 
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :destroy, :edit, :update]
    layout 'admin'

    def index
      add_breadcrumb "Marketplace", :admin_products_path
      @products = Marketplace::Product.all
    end

    def show
      add_breadcrumb "Marketplace", :admin_products_path
    end

    def new
      add_breadcrumb "Marketplace", :admin_products_path
      @product = Marketplace::Product.new
    end

    def edit
      add_breadcrumb "Marketplace", :admin_products_path
      authorize @product
    end

    def delete_image
      @image = ActiveStorage::Attachment.find(params[:id])
      @image.purge
      redirect_back(fallback_location: root_path)
    end    


    def create
      @product = Marketplace::Product.new(product_params)
      respond_to do |format|
        if @product.save
          format.html { redirect_to admin_product_path(@product), notice: 'Birth was successfully created.'}
          format.json { render :show, status: :created, location: @product}
        else
          format.html {render :new}
          format.json {render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      authorize @product
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to admin_product_path(@product), notice: 'Birth was successfully updated.'}
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit}
          format.json { render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @product.destroy
      respond_to do |format|
        format.html { redirect_to admin_products_path, notice: 'Birth was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Marketplace::Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :user_id, :phone, :location, :expiration, :approved, images: [])
    end
  end
end