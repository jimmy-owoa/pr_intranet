module Api::V1
  class HcCategoriesController < ApiController
    before_action :set_category, only: [:show]
    before_action :show?, only: [:show]

    def index
      categories = Helpcenter::Category.where(profile_id: @request_user.profile_ids)
      render json: categories, each_serializer: Helpcenter::CategorySerializer, status: :ok
    end

    def show
      render json: @category, serializer: Helpcenter::CategorySerializer, is_show: true, status: :ok
    end

    private

    def show?
      return if @category.profile_id.in?(@request_user.profile_ids)
      render json: { msg: "Not authorized", success: false }, status: :unauthorized
    end

    def set_category
      @category = Helpcenter::Category.find_by_slug(params[:slug])
      return record_not_found if @category.nil?
    end
  end
end