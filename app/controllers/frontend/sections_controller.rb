module Frontend
  class SectionsController < FrontendController
    def index
      sections = General::Section.all
      data = []
      sections.each do |section|
        if section.id == General::Section.first.id
          data << {
            id: section.id,
            title: section.title.upcase,
            description: section.description,
            position: section.position,
            image: url_for(section.image.variant(resize: '800x800>')),
            url: section.url
          }
        else
          data << {
            id: section.id,
            title: section.title.upcase,
            description: section.description,
            position: section.position,
            url: section.url
          }
        end
      end
      respond_to do |format|
        format.html
        format.json { render json: data }
        format.js
      end
    end
  end
end