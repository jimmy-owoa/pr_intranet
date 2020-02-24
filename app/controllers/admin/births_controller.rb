module Admin
  class BirthsController < AdminController
    before_action :set_birth, only: [:show, :destroy, :edit, :update]

    def index
      
      if params[:approved] == "true" || params[:approved] == "false"
        aprov = ActiveModel::Type::Boolean.new.cast(params[:approved])
        @births = Employee::Birth.order(created_at: :desc).approved_filter(aprov).paginate(:page => params[:page], :per_page => 10)
      else
        @births = Employee::Birth.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
      end
    end

    def no_approved_index
      @births = Employee::Birth.no_approved.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
    end

    def show
    end

    def new
      @birth = Employee::Birth.new
      @users = General::User.all.map { |u| [u.full_name, u.id] }
    end
    
    def edit
      @user = General::User.find(@birth.user_id) || nil
    end

    def create
      params[:birth][:gender] = params[:birth][:gender].to_i
      @birth = Employee::Birth.new(birth_params)
      @birth.user_id = params[:user_id]
      respond_to do |format|
        if @birth.save
          format.html { redirect_to admin_birth_path(@birth), notice: "Nacimiento fue creado con éxito." }
          format.json { render :show, status: :created, location: @birth }
        else
          format.html { render :new }
          format.json { render json: @birth.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      approved = params["approved"]
      if approved.present?
        respond_to do |format|
          if approved == "true"
            # UserNotifierMailer.send_birth_approved(@birth.user.email).deliver
          else
            # UserNotifierMailer.send_birth_not_approved(@birth.user.email).deliver
          end
          @birth.update_attributes(approved: approved)
          format.json { render :json => { value: "success" } and return }
        end
      elsif params["image_id"].present?
        ActiveStorage::Attachment.find(params["image_id"]).update_attributes(permission: 1)
      else
        respond_to do |format|
          if @birth.update(birth_params)
            catch_image(params[:permissions])
            format.html { redirect_to admin_birth_path(@birth), notice: "Nacimiento fue actualizado con éxito." }
            format.json { render :show, status: :ok, location: @birth }
          else
            format.html { render :edit }
            format.json { render json: @birth.errors, status: :unprocessable_entity }
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
      # UserNotifierMailer.send_birth_not_approved(@birth.user.email).deliver
      respond_to do |format|
        format.html { redirect_to admin_births_path, notice: "Nacimiento fue eliminado con éxito." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_birth
      @birth = Employee::Birth.find(params[:id])
    end

    def birth_params
      params.require(:birth).permit(:full_name_mother, :full_name_father, :child_name, :is_public, :child_lastname,
                                    :child_lastname2, :birthday, :approved, :gender, :user_id, images: [])
    end
  end
end
