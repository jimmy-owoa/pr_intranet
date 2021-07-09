module Api::V1
  class ProductsController < ApiController
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:create, :update, :update_expiration, :destroy]
    before_action :set_product, only: [:show, :update, :destroy, :user_product]

    def index
      page = params[:page] || 1
      category = params[:category] || "todos"

      if category == "todos"
        products = Marketplace::Product.approved_and_not_expired
      else
        products = Marketplace::Product.where(product_type: category).approved_and_not_expired
      end

      products = products.order(published_date: :desc).page(page).per(6)
      data = ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)

      render json: { products: data, meta: meta_attributes(products) }, status: :ok
    end

    def user_products
      page = params[:page] || 1
      category = params[:category] || "todos"

      if category == "todos"
        products = @request_user.products
      else
        products = @request_user.products.where(product_type: category)
      end

      products = products.order(published_date: :desc).page(page).per(6)
      data = ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer, is_user_product: true)
      render json: { products: data, meta: meta_attributes(products) }, status: :ok
    end

    def show
      render json: @product, serializer: ProductSerializer, is_show: true, status: :ok
    end

    def user_product
      render json: @product, serializer: ProductSerializer, is_show: true, is_user_product: true, status: :ok
    end

    def update
      id = params[:id] || nil
      @product = Marketplace::Product.find(id)
      set_params
      @product.update(name: @name, email: @email, price: @price, phone: @phone,
                      description: @description, location: @location, user_id: @user_id, product_type: @product_type, approved: false, expiration: 30)
      set_images true
      respond_to do |format|
        if @product
          format.json { render json: "ok", status: 200 }
        else
          format.json { render json: "error", status: 403 }
        end
      end
    end

    def create
      product = Marketplace::Product.new(product_params)
      product.user = @request_user

      if product.save
        render json: { success: true, message: "Product created"}, status: :created
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    def update_expiration
      product = Marketplace::Product.find(params[:id])
      product.update(published_date: Date.today, is_expired: false)
    end

    def destroy
      if @product.destroy
        render json: { success: true, message: "Product deleted"}, status: :created
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Marketplace::Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :phone, :location, :expiration, :approved, images: [])
    end
  end
end
