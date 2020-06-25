require "base64"
require "stringio"

module Api::V1
  class BirthsController < ApiController
    include ApplicationHelper
    #callbacks
    layout "admin"
    before_action :set_birth, only: [:show, :destroy]
    skip_before_action :verify_authenticity_token, only: [:create]

    def index
      page = params[:page]
      date = params[:date]

      if page.present? && date.present?
        all_births = Employee::Birth.show_birth.where("extract(year from birthday) = ?", Date.today.year).where("extract(month from birthday) = ?", date) #se cambio de un año a un mes
        births = all_births.order(:birthday).page(page).per(9)
        data_births = []
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
          # CORREGIR TODO NACIMIENTOS.
          if birth.photo.attachment
            if birth.permitted_image
              images << url_for(birth.photo.variant(resize: "500x500>"))
            end
          end
          # birth.permitted_images.map { |image| images << url_for(image.variant(resize: "500x500>")) }
          data_births << {
            id: birth.id,
            name: birth.child_name,
            last_names: birth.child_lastname + " " + birth.child_lastname2,
            company: company_name,
            photo: birth.photo.attachment ? url_for(birth.photo.attachment.variant(resize: "500x500>")) :  ActionController::Base.helpers.asset_path("birth.png"),
            images: images,
            gender: birth.gender,
            birthday: l(birth.birthday, format: "%d de %B").downcase,
            birthday_format_2: birth.birthday.strftime("%d-%m-%Y"),
            father: birth.user.present? ? get_full_favorite_name(birth.user) : "",
            email: email,
            color: color,
          }
        end
        data = { status: "ok", page: page, results_length: data_births.count, births: data_births }
        render json: data, status: :ok
      else
        render json: { status: "error", message: "bad request" }, status: :bad_request
      end
    end

    def get_home_births
      births = Employee::Birth.show_birth.order(birthday: :asc).last(4)
      data_births = []
      births.each do |birth|
        images = []
        if birth.photo.attachment
          if birth.permitted_image
            images << url_for(birth.photo.variant(resize: "500x500>"))
          end
        end

        data_births << {
          id: birth.id,
          child_full_name: birth.child_name + " " + birth.child_lastname + " " + birth.child_lastname2,
          photo: birth.permitted_image ? url_for(birth.photo.attachment.variant(resize: "500x500>")) :  ActionController::Base.helpers.asset_path("birth.png"),
          images: images,
          gender: birth.gender ? "Masculino" : "Femenino",
          birthday: birth.birthday.strftime("%d/%m"),
          father: birth.user.present? ? get_full_favorite_name(birth.user) : "",
          color: birth.user.present? ? birth.user.get_color : "black",
          email: birth.user.present? ? birth.user.email : "",
        }
      end
      data = { status: "ok", results_length: data_births.count, births: data_births }
      render json: data, status: :ok
    end

    def new
      add_breadcrumb "Nacimientos", :frontend_births_path
      @birth = Employee::Birth.new
    end

    def show
    end

    def create
      @birth = Employee::Birth.new(birth_params)

      respond_to do |format|
        if @birth.save
          render json: { status: "ok", birth: @birth }, status: :created
        else
          render json: { status: "error", message: @birth.errors }, status: :unprocessable_entity
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
                                    :child_lastname2, :birthday, :photo, :approved, :gender, :user_id)
    end
  end
end
