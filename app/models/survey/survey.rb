class Survey::Survey < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :survey_term_relationships, -> {where(object_type: 'Survey::Survey')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :survey
  has_many :terms, through: :survey_term_relationships
  has_one_attached :image

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |att| att['title'].blank? }
  accepts_nested_attributes_for :terms

  before_save :unique_slug, :set_survey_type

  SURVEY_TYPES = [['Encuesta','survey'],['Formulario','form']]
  
  def get_name_survey_type
    SURVEY_TYPES.find { |st| st[1] == self.survey_type }[0]
  end

  def get_answer_count 
    Survey::Answer.joins(:question).where(survey_questions: { survey_id: id }).count
  end
  private
  def set_survey_type
    self.survey_type = self.survey_type ||= 'survey'
  end

  def unique_slug
    self.slug = if self.slug.blank?
      self.name.blank? ? set_slug(self.get_name_survey_type) : set_slug(self.name.parameterize)   
      else
        set_slug(self.slug.parameterize)
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
