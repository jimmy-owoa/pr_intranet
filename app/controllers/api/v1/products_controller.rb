module Api::V1
  class ProductsController < ApiController
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:create, :update, :update_expiration, :destroy]
    before_action :set_product, only: [:show, :update, :destroy]

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
      page = params[:page]
      category = params[:category]

      if page.present? && category.present?
        if category == "todos"
          products = @request_user.products
        else
          products = @request_user.products.where(product_type: category)
        end
        products = products.order(published_date: :desc).page(page).per(6)
        data_products = []
        items = []
        products.each do |product|
          product.images.each do |image|
            if image.present?
              items << {
                src: url_for(image),
                thumbnail: url_for(image.variant(resize: "100x100")),
              }
            end
          end
          data_products << {
            id: product.id,
            name: product.name.capitalize,
            approved: product.approved,
            product_type: product.product_type,
            user_id: product.user_id,
            # url: "admin/products/" + "#{product.id}" + "/edit",
            currency: product.currency,
            price: product.price,
            published_date: product.published_date.present? ? l(product.published_date, format: "%d de %B, %Y").downcase : nil,
            is_expired: product.is_expired,
            expiration: product.expiration,
            description: product.description,
            main_image: product.images.first.present? ? url_for(product.images.first.variant(combine_options: { resize: "400>x300>", gravity: "Center" })) : "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
            items: product.images.present? ? items : "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png"
          }
        end
        data = { status: "ok", results_length: data_products.count, products: data_products, page: page, category: category }
        render json: data, status: :ok
      else
        render json: { status: 'error', message: 'bad request' }, status: :bad_request
      end
    end

    def show
      render json: @product, serializer: ProductSerializer, is_show: true, status: :ok
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
      Marketplace::Product.find(params[:id]).destroy
      respond_to do |format|
        format.json { head :no_content }
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
