class Survey::Survey < ApplicationRecord
  acts_as_paranoid
  searchkick match: :word, searchable: [:name]

  has_many :questions, dependent: :destroy
  has_many :survey_term_relationships, -> { where(object_type: "Survey::Survey") }, class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :survey
  has_many :answered_times
  has_one_attached :image

  belongs_to :profile, class_name: "General::Profile", optional: true, inverse_of: :surveys

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |att| att["title"].blank? }

  validates :name, presence: :true
  validates :allowed_answers, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "debe ser mayor o igual a 0" }

  after_initialize :set_status
  before_save :unique_slug, :set_survey_type, :set_published_at

  SURVEY_TYPES = [["Encuesta", "survey"], ["Formulario", "form"]]
  STATUS = ["Publicado", "Borrador", "Programado"]

  # scope :published_surveys, -> { where(status: "Publicado").order(published_at: :desc) }
  scope :published_surveys, -> { where("published_at <= ?", Time.now).where(status: ["Publicado", "Programado"]).order(published_at: :desc) }

  def set_status
    self.status ||= "Publicado"
  end

  def self.survey_data(user)
    @data_surveys = []
    surveys = []
    include_survey = Survey::Survey.where.not("finish_date <= ?", Date.today).or(Survey::Survey.where(finish_date: nil))
    include_survey = include_survey.includes(questions: [options: :answers]).where(once_by_user: true).published_surveys.where(profile_id: user.profile_ids)

    include_survey.each do |survey|
      if survey.allowed_answers.present?
        if survey.answered_times.count < survey.allowed_answers || survey.allowed_answers == 0
          survey.questions.each do |question|
            if user.id.in?(question.answers.pluck(:user_id))
              @data_surveys << survey
            end
          end
        else
          @data_surveys << survey
        end
      end
    end

    surveys << include_survey.where.not(id: @data_surveys.pluck(:id))
  end

  def self.get_surveys_no_once_user(user)
    allowed_surveys = []
    surveys = Survey::Survey.where.not("finish_date <= ?", Date.today).or(Survey::Survey.where(finish_date: nil))
    surveys = surveys.where(once_by_user: false).published_surveys.where.not("finish_date <= ?", Time.now).where(profile_id: user.profile_ids)

    surveys.each do |survey|
      if survey.answered_times.count < survey.allowed_answers || survey.allowed_answers == 0
        allowed_surveys << survey
      end
    end
    allowed_surveys
  end

  def self.sort_survey(data)
    data.partition { |x| x.is_a? String }.map(&:sort).flatten
  end

  def self.filter_surveys(id, data_surveys)
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
        survey[:inclusive_tags].each { |et| surveys << survey if et.in?(inclusive_tags) } if comparation == false
      elsif (survey[:excluding_tags].present? && survey[:inclusive_tags].blank?)
        surveys << survey if comparation
      elsif (survey[:inclusive_tags].present? && survey[:excluding_tags].blank?)
        survey[:inclusive_tags].each { |et| surveys << survey if et.in?(inclusive_tags) }
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
    Survey::Answer.joins(:question).where(survey_questions: { survey_id: id }).pluck(:user_id).uniq.count
  end

  private

  def set_survey_type
    self.survey_type = self.survey_type ||= "survey"
  end

  def set_published_at
    self.published_at = self.published_at || DateTime.now
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
      slug_split = val.split("-")
      if slug_split[-1].match? /^[0-9]+$/
        if slug_split.count > 1
          temp = slug_split[0..-2].join("-")
        else
          temp = slug_split[0]
        end
        set_slug(temp + "-" + random_number.to_s)
      else
        set_slug(val + "-" + random_number.to_s)
      end
    else
      val
    end
  end

  # def get_surveys
  #   General::Survey
  # end
end
