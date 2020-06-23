module Api::V1
  class LinksController < ApiController
    def index
      links = General::Link.last(8)
      data_links = []
      links.each do |link|
        data_links << {
          id: link.id,
          title: link.title,
          is_blank: link.is_blank,
          image: link.image.attached? ? url_for(link.image.variant(resize: "1920x")) : ActionController::Base.helpers.asset_path("noimage.png"),
          url: link.url,
        }
      end
      data = { status: 'ok', links: data_links, links_length: data_links.count }
      render json: data, status: :ok
    end
  end
end
