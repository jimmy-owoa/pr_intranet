module Admin 
  class BirthsController < ApplicationController
    before_action :set_birth, only: [:show, :destroy, :edit, :update]
    layout 'admin'
    def index
      add_breadcrumb "Nacimientos", :admin_births_path
      @births = Employee::Birth.paginate(:page => params[:page], :per_page => 10)
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
          format.html { redirect_to admin_birth_path(@birth), notice: 'Birth was successfully created.'}
          format.json { render :show, status: :created, location: @birth}
        else
          format.html {render :new}
          format.json {render json: @birth.errors, status: :unprocessable_entity}
        end
      end
    end

    def update
      params[:birth][:gender] = params[:birth][:gender].to_i
      respond_to do |format|
        if @birth.update(birth_params)
          catch_image(params[:permissions])
          format.html { redirect_to admin_birth_path(@birth), notice: 'Birth was successfully updated.'}
          format.json { render :show, status: :ok, location: @birth }
        else
          format.html { render :edit}
          format.json { render json: @birth.errors, status: :unprocessable_entity}
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
        format.html { redirect_to admin_births_path, notice: 'Birth was successfully destroyed.'}
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
      :birthday, :approved, :gender,  images: [])
    end

  end
end