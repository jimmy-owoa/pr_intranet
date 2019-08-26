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
          image: @image,
          link: benefit.url
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
      ln_user =  params[:ln_user]
      benefit = General::Benefit.find(id)
      benefit_group = General::User.find_by_legal_number(ln_user[0...-1]).benefit_group
      if benefit_group.benefits.include?(benefit)
      @image = @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + ActionController::Base.helpers.asset_url('news.jpg')
        data << {
          id: benefit.id,
          title: benefit.title,
          url: root_url + 'admin/benefit_groups/' + "#{benefit.id}" + '/edit',
          content: benefit.content,
          image: @image,
          link: benefit.url,
          benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name.downcase : '',
        }
      end
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