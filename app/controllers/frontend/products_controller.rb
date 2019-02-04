module Frontend
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :destroy, :edit, :update]

  #callbacks
  after_action :set_tracking, only: [:index, :show, :new]
  after_action :set_tracking_action, only: [:create, :update]

  def index
    products = Marketplace::Product.show_product
    data = []
    normal_sizes = []
    large_sizes = []
    thumb_sizes = []
    products.each do |product|
      product.images.each do |image|
        thumb_sizes << {
          id: image.id,
          url: @ip.to_s + rails_representation_url(image.variant(resize: '100x100'), only_path: true)
        }
        normal_sizes << {
          id: image.id,
          url: @ip.to_s + rails_representation_url(image.variant(resize: '480x300'), only_path: true)
        }
        large_sizes << {
          id: image.id,
          url: @ip.to_s + rails_blob_url(image, only_path: true)
        }
      end
      data << {
        id: product.id,
        name: product.name,
        product_type: product.product_type,
        user_id: General::User.find(product.user_id).name,
        created_at: product.created_at.strftime("%d/%m/%Y %H:%M"),
        price: product.price,
        location: product.location,
        email: product.email,
        phone: product.phone,
        description: product.description,
        main_image: @ip.to_s + (  product.images.first.present? ? rails_representation_url(product.images.first.variant(resize: '320x320'), only_path: true) : '/assets/noimage.jpg'),
        images: product.images.present? ? {
          thumbs: thumb_sizes,
          normal_size: normal_sizes,
          large_size: large_sizes
        } : @ip.to_s + '/assets/noimage.jpg'
      }
      thumb_sizes = []
      normal_sizes = []
      large_sizes = []
    end
    respond_to do |format|
      format.html
      format.json { render json: data }
      format.js
    end
  end

    def new
      @product = Marketplace::Product.new
    end

    def edit
    end

    def create
      @product = Marketplace::Product.new(product_params)
      respond_to do |format|
        if @product.save
          format.html { redirect_to frontend_product_path(@product), notice: 'Birth was successfully created.'}
          format.json { render :show, status: :created, location: @product}
        else
          format.html {render :new}
          format.json {render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end
    
    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to frontend_product_path(@product), notice: 'Birth was successfully updated.'}
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit}
          format.json { render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end

  private

    def set_tracking
      ahoy.track "Product Model", params
    end

    def set_tracking_action
      ahoy.track "Product Model / Actions", controller: params[:controller], action: params[:action], product: params[:product][:name]
    end

    def set_product_types
      @product_types = General::Term.product_types
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Marketplace::Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :user_id, :phone, :location, :expiration, :approved, images: [])
    end
  end
end