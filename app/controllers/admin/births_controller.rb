module Admin 
  class BirthsController < AdminController
    before_action :set_birth, only: [:show, :destroy, :edit, :update]

    def index
      add_breadcrumb "Nacimientos", :admin_births_path
      if params[:approved] == 'true' || params[:approved] == 'false'
        aprov = ActiveModel::Type::Boolean.new.cast(params[:approved])
        @births = Employee::Birth.approved_filter(aprov).paginate(:page => params[:page], :per_page => 10)
      else
        @births = Employee::Birth.paginate(:page => params[:page], :per_page => 10)
      end
    end

    def no_approved_index
      @births = Employee::Birth.no_approved.paginate(:page => params[:page], :per_page => 10)
    end

    def show
      add_breadcrumb "Nacimientos", :admin_births_path
    end

    def new
      add_breadcrumb "Nacimientos", :admin_births_path
      @birth = Employee::Birth.new
    end

    def edit
      add_breadcrumb "Nacimientos", :admin_births_path
    end

    def create
      params[:birth][:gender] = params[:birth][:gender].to_i
      @birth = Employee::Birth.new(birth_params)
      respond_to do |format|
        if @birth.save
          format.html { redirect_to admin_birth_path(@birth), notice: 'Nacimiento fue creado con éxito.'}
          format.json { render :show, status: :created, location: @birth}
        else
          format.html {render :new}
          format.json {render json: @birth.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      if params['approved'].present?
        respond_to do |format|
          @birth.update_attributes(approved: params['approved'])
          format.json { render :json => {value: "success"} and return}
        end
      elsif params['image_id'].present?
        ActiveStorage::Attachment.find(params['image_id']).update_attributes(permission: 1)
      else
        params[:birth][:gender] = params[:birth][:gender].to_i
        respond_to do |format|
          if @birth.update(birth_params)
            catch_image(params[:permissions])
            format.html { redirect_to admin_birth_path(@birth), notice: 'Nacimiento fue actualizado con éxito.'}
            format.json { render :show, status: :ok, location: @birth }
          else
            format.html { render :edit}
            format.json { render json: @birth.errors, status: :unprocessable_entity}
          end
        end
      end
    end

    def catch_image(image)
      if image.present?
        image.each do |id|
          ActiveStorage::Attachment.find(id).update_attributes(permission: 1)
        end
      end
    end

   def delete_image
      @image = ActiveStorage::Attachment.find(params[:id])
      @image.purge
      redirect_back(fallback_location: root_path)
    end

    def destroy
      @birth.destroy
      respond_to do |format|
        format.html { redirect_to admin_births_path, notice: 'Nacimiento fue eliminado con éxito.'}
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_birth
      @birth = Employee::Birth.find(params[:id])
    end

    def birth_params
      params.require(:birth).permit(:full_name_mother, :full_name_father, :child_name, :child_lastname,
        :child_lastname2, :birthday, :approved, :gender, :user_id, images: [])
    end

  end
end