module Api::V1
  class SectionsController < ApiController
    def index
      sections = General::Section.order(position: :asc)
      data = ActiveModel::Serializer::CollectionSerializer.new(sections, serializer: SectionSerializer)

      render json: { data: data, success: true }, status: :ok
    end
  end
end
