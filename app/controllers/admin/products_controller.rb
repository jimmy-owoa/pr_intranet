module Admin 
  class ProductsController < AdminController
    before_action :set_product, only: [:show, :destroy, :edit, :update]
    
    def index
      add_breadcrumb "Marketplace", :admin_products_path
      @filters = [['Todos', 'all'], ['Aprobados', true], ['Sin aprobación', false]]
      is_approved = params[:approved]
      @products = Marketplace::Product.get_filtered(is_approved).paginate(:page => params[:page], :per_page => 10)
    end

    def no_approved_index
      @products = Marketplace::Product.no_approved.paginate(:page => params[:page], :per_page => 10)
    end

    def approved_index
      @products = Marketplace::Product.approved.paginate(:page => params[:page], :per_page => 10)
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
          @product.update_attributes(user_id: current_user.id)
          format.html { redirect_to admin_product_path(@product), notice: 'Producto fue creada con éxito.'}
          format.json { render :show, status: :created, location: @product}
        else
          format.html {render :new}
          format.json {render json: @product.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      authorize @product
      if params['approved'].present?
        respond_to do |format|
          @product.update_attributes(approved: params['approved'])
          format.json { render :json => {value: "success"} and return}
        end
      elsif params["product"]["approved"].present?
          @product.update_attributes(approved: params["product"]["approved"])
          @product.update(product_params)
          redirect_to request.referrer, notice: "Aprobado"
      elsif params['image_id'].present?
        ActiveStorage::Attachment.find(params['image_id']).update_attributes(permission: 1)
      else
        respond_to do |format|
          if @product.update(product_params)
            catch_image(params[:permissions])
            format.html { redirect_to admin_product_path(@product), notice: 'Producto fue actualizado con éxito.'}
            format.json { render :show, status: :ok, location: @product }
          else
            format.html { render :edit}
            format.json { render json: @product.errors, status: :unprocessable_entity}
          end
        end
      end
    end

    def destroy
      @product.destroy
      respond_to do |format|
        format.html { redirect_to admin_products_path, notice: 'Producto fue eliminado con éxito.'}
        format.json { head :no_content }
      end
    end

    def catch_image(image)
      if image.present?
        image.each do |id|
          ActiveStorage::Attachment.find(id).update_attributes(permission: 1)
        end
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Marketplace::Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :product_type, :price, :email, :currency, :user_id, :phone, :location, :expiration, :approved, images: [])
    end
  end
end