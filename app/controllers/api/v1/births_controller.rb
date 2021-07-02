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
      page = params[:page] || 1
      month = params[:month] || 1

      births = Employee::Birth.get_births_index(page, month)
      data = ActiveModel::Serializer::CollectionSerializer.new(births, serializer: BirthSerializer, is_index: true)

      render json: { births: data, meta: meta_attributes(births) }, status: :ok
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

    def create
      birth = Employee::Birth.new(birth_params)

      if birth.save
        render json: { success: true, message: "Birth created"}, status: :created
      else
        render json: { success: false, message: "Error" }, status: :unprocessable_entity
      end
    end

    private

    def set_birth
      @birth = Employee::Birth.find(params[:id])
    end

    def birth_params
      params.require(:birth).permit(:is_public, :child_name, :child_lastname,
                                    :child_lastname2, :birthday, :photo, :approved, :gender, :user_id)
    end
  end
end
