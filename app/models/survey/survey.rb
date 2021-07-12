class Survey::Survey < ApplicationRecord
  acts_as_paranoid
  # searchkick match: :word, searchable: [:name]

  has_many :questions, dependent: :destroy
  has_many :answered_times
  
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  belongs_to :profile, class_name: "General::Profile", optional: true, inverse_of: :surveys

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |att| att["title"].blank? }

  validates :name, presence: :true
  validates :allowed_answers, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "debe ser mayor o igual a 0" }

  after_initialize :set_status
  before_save :unique_slug, :set_published_at

  STATUS = ["Publicado", "Borrador", "Programado"]

  scope :no_finished, -> { where.not("finish_date <= ?", Date.today).or(Survey::Survey.where(finish_date: nil)) }
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

  def self.get_surveys(current_user)
    self.includes(:questions).where(profile_id: current_user.profile_ids).no_finished.published_surveys
  end

  def self.get_surveys_no_once_user(user)
    allowed_surveys = []
    surveys = Survey::Survey.where.not("finish_date <= ?", Date.today).or(Survey::Survey.where(finish_date: nil))
    surveys = surveys.where(once_by_user: false).published_surveys.where(profile_id: user.profile_ids)
    surveys.each do |survey|
      if survey.answered_times.count < survey.allowed_answers || survey.allowed_answers == 0
        allowed_surveys << survey
      end
    end
    allowed_surveys
  end

  def self.get_surveys_once_user(user)
    allowed_surveys = []
    surveys = surveys.no_finished.where(once_by_user: false).published_surveys
    surveys.each do |survey|
      if survey.answered_times.count < survey.allowed_answers || survey.allowed_answers == 0
        allowed_surveys << survey
      end
    end
    allowed_surveys
  end

  def get_answer_count
    Survey::Answer.joins(:question).where(survey_questions: { survey_id: id }).pluck(:user_id).uniq.count
  end

  private

  def set_published_at
    self.published_at = self.published_at || DateTime.now
  end

  def unique_slug
    self.slug = if self.slug.blank?
                  set_slug(self.name.parameterize)
                else
                  set_slug(self.slug.parameterize)
                end
  end

  def set_slug(val)
    survey_by_slug = Survey::Survey.find_by(slug: val) || Survey::Survey.only_deleted.find_by(slug: val)
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
end
