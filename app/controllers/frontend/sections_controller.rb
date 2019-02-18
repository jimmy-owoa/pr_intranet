module Frontend
  class SectionsController < ApplicationController
    def index
      sections = General::Section.all
      data = []
      sections.each do |section|
        data << {
          title: section.title,
          description: section.description,
          position: section.position,
          image: url_for(section.image.variant(resize: '800x800>')),
          url: section.url,
          created: section.created_at
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