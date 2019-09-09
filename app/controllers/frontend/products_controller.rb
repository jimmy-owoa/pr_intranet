module Frontend
  class ProductsController < FrontendController
    before_action :set_product, only: [:show, :destroy, :edit, :update]

    #callbacks
    after_action :set_tracking, only: [:index, :show, :new]

    def index
      page = params[:page]
      category = params[:category]
      if category == "all"
        products = Marketplace::Product.show_product
      else
        products =  Marketplace::Product.where(product_type: category).show_product
      end
      products = products.order(:published_date).page(page).per(6)
      data = []
      items = []
      products.each do |product|
        product.images.each do |image|
          if image.present?
            items << {
              src: url_for(image),
              thumbnail: url_for(image.variant(resize: "100x100"))
            }
          end
        end
        data << {
          id: product.id,
          name: product.name,
          approved: product.approved,
          product_type: product.product_type,
          user_id: product.user_id,
          url: root_url + 'admin/products/' + "#{product.id}" + '/edit',
          currency: product.currency,
          price: product.price,
          is_expired: product.is_expired,
          expiration: product.expiration,
          description: product.description,
          main_image: product.images.first.present? ? url_for(product.images.first.variant(combine_options: {resize: "400>x300>", gravity: 'Center' })) :  root_url + ActionController::Base.helpers.asset_url('noimage.png'),
          items: product.images.present? ? items : root_url + ActionController::Base.helpers.asset_url('noimage.png'),
          breadcrumbs: [
            {link: '/', name: 'Inicio' },
            {link: '/avisos', name: 'Avisos Clasificados'},
            {link: '#', name: product.name.truncate(30)}
          ]
        }
      end
      respond_to do |format|
        format.json { render json: {hits: data} }
        format.js
      end
    end

    def product
      id = params[:id].present? ? params[:id] : nil
      product = Marketplace::Product.where(id: id).first
      data = []
      items = []
      product.images.each do |image|
        if image.present?
          items << {
            src: url_for(image.variant(combine_options: {resize: "600x400>", gravity: 'Center' })),
            thumbnail: url_for(image.variant(resize: "100x100"))
          }
        end
      end
      data << {
        id: product.id,
        name: product.name,
        description: product.description,
        type: product.product_type,
        currency: product.currency,
        price: product.price,
        published_date: product.published_date.present? ?  product.published_date.strftime("%d/%m/%Y") : '',
        email: product.email,
        phone: product.phone,
        tags: product.terms.tags,
        location: product.location,
        approved: product.approved,
        user_id: product.user_id,
        user_company: product.user.company.present? ? product.user.company.name : "",
        user_full_name: General::User.find(product.user_id).full_name,
        is_expired: product.is_expired,
        items: product.images.present? ? items : 
        [{
          src: root_url + ActionController::Base.helpers.asset_url('noimage.png'),
          thumbnail: root_url + ActionController::Base.helpers.asset_url('noimage.png')
        }],
        breadcrumbs: [
          {link: '/', name: 'Inicio' },
          {link: '/avisos-clasificados', name: 'Avisos clasificados'},
          {link: '#', name: 'Aviso' }
        ],
      }
      respond_to do |format|
        format.json { render json: data[0] }
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