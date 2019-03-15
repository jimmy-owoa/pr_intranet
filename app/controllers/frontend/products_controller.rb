module Frontend
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :destroy, :edit, :update]

  #callbacks
  after_action :set_tracking, only: [:index, :show, :new]

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
          url: url_for(image.variant(resize: "100x100"))
        }
        normal_sizes << {
          id: image.id,
          url: url_for(image.variant(resize: "500x500>"))
        }
        large_sizes << {
          id: image.id,
          url: url_for(image)
        }
      end
      data << {
        id: product.id,
        name: product.name,
        product_type: product.product_type,
        user_id: General::User.find(product.user_id).id,
        created_at: product.created_at.strftime("%d/%m/%Y %H:%M"),
        price: product.price,
        location: product.location,
        email: product.email,
        phone: product.phone,
        is_expired: product.is_expired,
        expiration: product.expiration,
        description: product.description,
        main_image: product.images.first.present? ? url_for(product.images.first) : nil,
        images: product.images.present? ? {
          thumbs: thumb_sizes,
          normal_size: normal_sizes,
          large_size: large_sizes
        } : root_url + '/assets/noimage.jpg',
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/avisos', name: 'Avisos'},
          {link: '#', name: product.name.truncate(30)}
        ]
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
      name = params[:name]
      email = params[:email]
      price = params[:price]
      phone = params[:phone]
      description = params[:description]
      location = params[:location]
      user_id = params[:user_id]
      images = params[:images]
      product_type = params[:product_type]

      @product = Marketplace::Product.new(name: name, email: email, price: price, phone: phone, 
        description: description, location: location, user_id: user_id, approved: false, expiration: 30)
      if images.present? 
        images.each do |image|
          base64_image = image[1].sub(/^data:.*,/, '')
          decoded_image = Base64.decode64(base64_image)
          image_io = StringIO.new(decoded_image)
          @product_image = { io: image_io, filename: name }  
          @product.images.attach(@product_image)
        end
      end
      respond_to do |format|
        if @product.save
          format.html { redirect_to frontend_product_path(@product), notice: 'Product was successfully created.'}
          format.json { render :show, status: :created, location: @product}
        else
          format.html {render :new}
          format.json {render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end
    
    def update_expiration
      product = Marketplace::Product.find(params[:id])
      product.update(published_date: Date.today, is_expired: false)
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
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :user_id, :phone, :location, :expiration, :approved, :published_date, images: [])
    end
  end
end