class Survey::Survey < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :survey_term_relationships, -> {where(object_type: 'Survey::Survey')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :survey
  has_many :terms, through: :survey_term_relationships
  has_one_attached :image

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |att| att['title'].blank? }
  accepts_nested_attributes_for :terms

  validates :name, presence: :true

  after_initialize :set_status
  before_save :unique_slug, :set_survey_type

  SURVEY_TYPES = [['Encuesta','survey'],['Formulario','form']]
  STATUS = ['Publicado','Borrador', 'Programado']

  scope :published_surveys, -> { where(status: "Publicado").order(published_at: :desc)}

  def set_status
    self.status ||= 'Publicado'
  end

  def self.survey_data user_id
    @data_surveys = []
    include_survey = self.includes(questions: [options: :answers])
    include_survey.where(once_by_user: true).published_surveys.each do |survey|
      survey.questions.where(optional: true).each do |question|
        #sumamos surveys si no tiene alguna respuesta
        @data_surveys << survey if question.answers.blank?
        question.answers.each do |answer|
          #sumamos surveys si tiene respuesta pero ninguna con el id del usuario
          @data_surveys << survey if answer.user_id != user_id.to_i
        end
      end
    end
    #sumamos surveys que se pueden responder más de una vez
    @data_surveys.uniq << include_survey.where(once_by_user: false)
  end

  def self.sort_survey data
    data.partition{|x| x.is_a? String}.map(&:sort).flatten
  end

  def self.filter_surveys id, data_surveys
    surveys = []
    user = General::User.find(id)
    user_tags = user.terms.tags.map(&:name)
    excluding_tags = user.terms.tags.excluding_tags.map(&:name)
    inclusive_tags = user.terms.tags.inclusive_tags.map(&:name)
    data_surveys.each do |survey|
      comparation = sort_survey(survey[:excluding_tags]) == sort_survey(excluding_tags)
      #toma los terms excluyentes del usuario y los del survey, los ordena y compara. Si no son iguales, no los agrega al array surveys.
      if (survey[:excluding_tags].present? && survey[:inclusive_tags].present?)
        surveys << survey if comparation
        survey[:inclusive_tags].each{|et| surveys << survey if et.in?(inclusive_tags) } if comparation == false
      elsif (survey[:excluding_tags].present? && survey[:inclusive_tags].blank?)
        surveys << survey if comparation
      elsif (survey[:inclusive_tags].present? && survey[:excluding_tags].blank?)
        survey[:inclusive_tags].each{|et| surveys << survey if et.in?(inclusive_tags) }
      else
        surveys << survey
      end
    end
    surveys.uniq
  end

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
