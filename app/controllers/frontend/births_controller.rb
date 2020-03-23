require "base64"
require "stringio"

module Frontend
  class BirthsController < FrontendController
    #callbacks
    layout "admin"
    before_action :set_birth, only: [:show, :destroy]
    skip_before_action :verify_authenticity_token, only: [:create]

    def index
      page = params[:page]
      date = params[:date]
      all_births = Employee::Birth.show_birth.where("extract(year from birthday) = ?", Date.today.year).where("extract(month from birthday) = ?", date) #se cambio de un año a un mes
      births = all_births.order(:birthday).page(page).per(9)
      data = []
      births.each do |birth|
        if birth.user.present?
          email = birth.user.email
          color = birth.user.get_color
          company_name = birth.user.company.name
        else
          email = "sin email"
          color = "black"
        end
        images = []

        if birth.photo.attachment          
          if birth.permitted_image
            images << url_for(birth.photo.variant(resize: "500x500>"))
          end
        end
        # birth.permitted_images.map { |image| images << url_for(image.variant(resize: "500x500>")) }
        data << {
          id: birth.id,
          name: birth.child_name,
          last_names: birth.child_lastname + " " + birth.child_lastname2,
          company: company_name,
          photo: birth.photo.attachment ? url_for(birth.photo.attachment.variant(resize: "500x500>")) : root_url + ActionController::Base.helpers.asset_url("birth.png"),
          images: images,
          gender: birth.gender,
          birthday: l(birth.birthday, format: "%d de %B").downcase,
          birthday_format_2: birth.birthday.strftime("%d-%m-%Y"),
          father: birth.user.present? ? birth.user.full_name : "",
          email: email,
          color: color,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: { hits: data } }
        format.js
      end
    end

    def get_home_births
      data = []
      births = Employee::Birth.show_birth.order(birthday: :asc).last(4)
      births.each do |birth|
        images = []

      if birth.photo.attachment
        if birth.permitted_image
          images << url_for(birth.photo.variant(resize: "500x500>"))
        end        
      end

        data << {
          id: birth.id,
          child_full_name: birth.child_name + " " + birth.child_lastname + " " + birth.child_lastname2,
          photo: birth.permitted_image ? url_for(birth.photo.attachment.variant(resize: "500x500>")) : root_url + ActionController::Base.helpers.asset_url("birth.png"),
          images: images,
          gender: birth.gender ? "Masculino" : "Femenino",
          birthday: birth.birthday,
          father: birth.user.present? ? birth.user.favorite_name : "",
          color: birth.user.present? ? birth.user.get_color : "black",
          email: birth.user.present? ? birth.user.email : "",
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end

    def new
      add_breadcrumb "Nacimientos", :frontend_births_path
      @birth = Employee::Birth.new
    end

    def show
    end

    def create
      child_name = params[:child_name]
      child_lastname = params[:child_lastname]
      child_lastname2 = params[:child_lastname2]
      user_id = params[:user_id]
      is_public = params[:is_public]
      approved = params[:approved]
      gender = params[:gender]
      birthday = params[:birthday]
      images = params[:images]
      user_id = params[:user_id]
      @birth = Employee::Birth.new(child_name: child_name, child_lastname: child_lastname, child_lastname2: child_lastname2, user_id: user_id,
                                   approved: approved, gender: gender, birthday: birthday, is_public: is_public)
      if images.present?
        images.each do |image|
          base64_image = image[1].sub(/^data:.*,/, "")
          decoded_image = Base64.decode64(base64_image)
          image_io = StringIO.new(decoded_image)
          @birth_image = { io: image_io, filename: child_name }
          @birth.photo.attach(@birth_image)
        end
      end
      respond_to do |format|
        if @birth.save
          # UserNotifierMailer.send_birth_created(@birth.user.email).deliver
          format.html { redirect_to frontend_birth_path(@birth), notice: "Birth was successfully created." }
          format.json { render json: @birth, status: 200 }
        else
          format.html { render :new }
          format.json { render json: @birth.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @birth.destroy
      respond_to do |format|
        format.html { redirect_to admin_births_path, notice: "Birth was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_birth
      @birth = Employee::Birth.find(params[:id])
    end

    def birth_params
      params.require(:birth).permit(:full_name_mother, :full_name_father, :is_public, :child_name, :child_lastname,
                                    :child_lastname2, :birthday, :photo, :approved, :gender)
    end
  end
end
