module Frontend
  class LinksController < ApplicationController
    def index
      links = General::Link.last(6)
      data = []
      links.each do |link|
        data << {
          id: link.id,
          title: link.title,
          created_at: l(link.created_at, format: '%A %d %B %Y'),
          image: root_url.to_s + rails_representation_url(link.image.variant(resize: '200x200>'), only_path: true),
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