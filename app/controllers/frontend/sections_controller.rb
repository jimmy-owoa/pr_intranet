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
          image: @ip.to_s + rails_representation_url(section.image.variant(resize: '800x800>'), only_path: true),
          url: section.url
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