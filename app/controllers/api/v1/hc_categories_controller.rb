module Api::V1
  class HcCategoriesController < ApiController
    before_action :set_category, only: [:show]

    def index
      categories = Helpcenter::Category.all
      render json: categories, each_serializer: Helpcenter::CategorySerializer, status: :ok
    end

    def show
      render json: @category, serializer: Helpcenter::CategorySerializer, is_show: true, status: :ok
    end

    private

    def set_category
      @category = Helpcenter::Category.find_by_slug(params[:slug])
      return record_not_found if @category.nil?
    end
  end
end