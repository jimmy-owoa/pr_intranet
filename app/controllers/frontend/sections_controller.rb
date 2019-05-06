module Frontend
  class SectionsController < FrontendController
    def index
      sections = General::Section.all
      data = []
      sections.each do |section|
        data << {
          id: section.id,
          title: section.title.upcase,
          description: section.description,
          position: section.position,
          image: url_for(section.image.variant(resize: '800x800>')),
          url: section.url,
          created: section.created_at,
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