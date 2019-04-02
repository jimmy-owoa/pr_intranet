module Frontend
  class LinksController < FrontendController
    def index
      links = General::Link.last(6)
      data = []
      links.each do |link|
        data << {
          id: link.id,
          title: link.title,
          created_at: l(link.created_at, format: '%A %d %B %Y'),
          image: url_for(link.image.variant(resize: '200x200>')),
          url: link.url
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