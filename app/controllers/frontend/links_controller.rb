module Frontend
  class LinksController < ApplicationController
    def index
      links = General::Link.all
      data = []
      links.each do |link|
        data << {
          id: link.id,
          title: link.title,
          created_at: l(link.created_at, format: '%A %d %B %Y'),
          image: @ip.to_s + rails_representation_url(link.image.variant(resize: '200x200'), only_path: true)
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