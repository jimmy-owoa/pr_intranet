module Api::V1
  class LinksController < ApiController
    def index
      links = General::Link.all
      data = ActiveModel::Serializer::CollectionSerializer.new(links, serializer: LinkSerializer)

      render json: { data: data, success: true }, status: :ok
    end
  end
end
