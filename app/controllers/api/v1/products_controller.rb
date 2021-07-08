module Api::V1
  class ProductsController < ApiController
    include ApplicationHelper
    skip_before_action :verify_authenticity_token, only: [:create, :update, :update_expiration, :destroy]

    def index
      page = params[:page]
      category = params[:category]

      if category.present? && page.present?
        if category == "todos"
          products = Marketplace::Product.approved_and_not_expired
        else
          products = Marketplace::Product.where(product_type: category).approved_and_not_expired
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
            name: product.name,
            approved: product.approved,
            product_type: product.product_type,
            user_id: product.user_id,
            # url: "admin/products/" + "#{product.id}" + "/edit",
            currency: product.currency,
            price: product.price,
            is_expired: product.is_expired,
            expiration: product.expiration,
            description: product.description,
            main_image: product.permitted_images.present? ? url_for(product.permitted_images.first.variant(combine_options: { resize: "400>x300>", gravity: "Center" })) : "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
            items: product.images.present? ? items : "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
            breadcrumbs: [
              { link: "/", name: "Inicio" },
              { link: "/avisos", name: "Avisos Clasificados" },
              { link: "#", name: product.name.truncate(30) },
            ],
          }
        end
        data = { status: "ok", page: page, category: category, results_length: data_products.count, products: data_products }
        render json: data, status: :ok
      else
        render json: { status: "error", message: "bad request"}, status: :bad_request
      end
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

    def product
      id = params[:id]

      if id.present?
        product = Marketplace::Product.where(id: id).first
        items = []
        product_images = params[:myProduct] == "true" ? product.images : product.permitted_images
        product_images.each do |image|
          if image.present?
            items << {
              src: url_for(image.variant(combine_options: { resize: "600x400>", gravity: "Center" })),
              thumbnail: url_for(image.variant(resize: "100x100")),
            }
          end
        end
        
        data_product = {
          id: product.id,
          name: product.name,
          description: product.description,
          type: product.product_type,
          currency: product.currency,
          price: product.price,
          published_date: product.published_date.present? ? product.published_date.strftime("%d/%m/%Y") : "",
          email: product.email,
          phone: product.phone,
          location: product.location,
          approved: product.approved,
          user_id: product.user_id,
          user_company: product.user.company.present? ? product.user.company.name : "",
          user_full_name: General::User.find(product.user_id).full_name,
          is_expired: product.is_expired,
          # admin_url: admin_product_path(product.id),
          items: product.images.present? ? items :
            [{
            src: "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
            thumbnail: "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
          }],
        }
        breadcrumbs = [
          { href: "/", text: "Inicio", disabled: false },
          { href: "/avisos-clasificados", text: "Avisos clasificados", disabled: false },
          { href: "#", text: "Aviso", disabled: true },
        ]
        
        data = { status: "ok", breadcrumbs: breadcrumbs, product: data_product }
        render json: data
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end

    def new
      @product = Marketplace::Product.new
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
        render json: { status: "ok", product: product }, status: :created
      else
        render json: { status: "error", message: product.errors }, status: :unprocessable_entity
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

    def set_product_types
      @product_types = General::Term.product_types
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Marketplace::Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :phone, :location, :expiration, :approved, images: [])
    end
  end
end
