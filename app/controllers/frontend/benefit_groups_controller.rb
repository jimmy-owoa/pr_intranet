module Frontend
  class BenefitGroupsController < FrontendController
    def index
      benefit_groups = General::BenefitGroup.all.map(&:name)
      respond_to do |format|
        format.html
        format.json { render json: benefit_groups }
        format.js
      end
    end

    def benefits_group
      data = []
      benefit_group = @request_user.benefit_group
      benefit_group_name = benefit_group.name
      benefit_group.benefits.order(:benefit_type, :id) do |benefit|
        @image = benefit.image.present? ? url_for(benefit.image.attachment) : root_url + '/assets/news.jpg'
        data << {
          benefit_group_name: benefit_group_name,
          id: benefit.id,
          title: benefit.title,
          content: benefit.content,
          url: root_url + 'admin/benefit_groups/' + "#{benefit.id}" + '/edit',
          image: @image,
          benefit_type: benefit.benefit_type.present? ? benefit.benefit_type.name.downcase : ''
        }
      end
      respond_to do |format|
        format.json { render json: data }
        format.js
      end
    end

  end
end