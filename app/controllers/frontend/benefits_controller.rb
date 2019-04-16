module Frontend
  class BenefitsController < FrontendController
    after_action :set_tracking, only: [:index, :show]

    def index
      benefits = General::Benefit.all
      data = []
      benefits.each do |benefit|
        @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + '/assets/
        news.jpg'
        data << {
          id: benefit.id,
          title: benefit.title,
          url: root_url + 'admin/benefit_groups/' + "#{benefit.id}" + '/edit',
          content: benefit.content,
          image: @image
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

    def benefit
      data = []
      id = params[:id].present? ? params[:id] : nil
      benefit = General::Benefit.find(id)
      @image = @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + '/assets/news.jpg'
      data << {
        id: benefit.id,
        title: benefit.title,
        url: root_url + 'admin/benefit_groups/' + "#{benefit.id}" + '/edit',
        content: benefit.content,
        image: @image
      }
      respond_to do |format|
        format.json { render json: data[0] }
        format.js
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @benefit }
        format.js
      end
    end

    private
    def set_tracking
      ahoy.track "Benefit Model", params
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @attachment = General::Benefit.find(params[:id])
    end

  end
end