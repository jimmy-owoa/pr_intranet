class Survey::Survey < ApplicationRecord
  has_many :questions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |att| att['title'].blank? }

  before_save :unique_slug, :set_survey_type

  SURVEY_TYPES = [['Encuesta','survey'],['Formulario','form']]

  private
  def set_survey_type
    self.survey_type = self.survey_type ||= 'survey'
  end

  def unique_slug
    self.slug = if self.slug.nil?
        set_slug(self.name.parameterize)
      else
        set_slug(self.slug)
      end
  end

  def set_slug(val)
    survey_by_slug = Survey::Survey.find_by(slug: val)
    if survey_by_slug.present? && survey_by_slug != self
      random_number = rand(1000..9999)
      slug_split = val.split('-')
      if slug_split[-1].match? /^[0-9]+$/
        if slug_split.count > 1
          temp = slug_split[0..-2].join('-')
        else
          temp = slug_split[0]
        end
        set_slug(temp + '-' + random_number.to_s)
      else
        set_slug(val + '-' + random_number.to_s)
      end
    else
      val
    end
  end
end
