module Api::V1
  class LinksController < ApiController
    def index
      links = General::Link.last(8)
      data = []
      links.each do |link|
        data << {
          id: link.id,
          title: link.title,
          is_blank: link.is_blank,
          image: link.image.attached? ? url_for(link.image.variant(resize: "1920x")) : root_url + ActionController::Base.helpers.asset_url("noimage.png"),
          url: link.url,
        }
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end
  end
end
