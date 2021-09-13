module Api::V1
  class HcSubcategoriesController < ApiController
    before_action :set_subcategory, only: [:show]

    def show
      render json: @subcategory, serializer: Helpcenter::SubcategorySerializer, is_show: true, status: :ok
    end

    private

    def set_subcategory
      @subcategory = Helpcenter::Subcategory.find_by_slug(params[:slug])
      return record_not_found if @subcategory.nil?
    end
  end
end
