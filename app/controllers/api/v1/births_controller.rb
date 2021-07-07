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

    def home_births
      births = Employee::Birth.public_births.order(birthday: :desc).first(4)

      render json: births, each_serializer: BirthSerializer, status: :ok
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
