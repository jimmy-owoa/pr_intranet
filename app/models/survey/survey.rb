class Survey::Survey < ApplicationRecord
  include Rails.application.routes.url_helpers
  acts_as_paranoid
  # searchkick match: :word, searchable: [:name]

  has_many :questions, dependent: :destroy
  has_many :answered_times
  has_many :answered_forms
  
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

  def self.get_surveys(current_user)
    surveys_filtered = self.includes(:questions).where(profile_id: current_user.profile_ids).no_finished.published_surveys
    surveys = surveys_filtered.get_no_once_user + surveys_filtered.get_once_user(current_user)

    data = []
    surveys.each do |survey|
      data << survey if survey.allows_answers?
    end

    return data
  end

  def allows_answers?
    self.answered_times.count < self.allowed_answers || self.allowed_answers == 0
  end

  def self.get_no_once_user()
    return self.where(once_by_user: false)
  end

  def self.get_once_user(current_user)
    surveys = self.where(once_by_user: true)

    data = []
    surveys.each do |survey|
      data << survey if !survey.answered_forms.where(user: current_user).exists?
    end

    data
  end

  def get_answer_count
    Survey::Answer.joins(:question).where(survey_questions: { survey_id: id }).pluck(:user_id).uniq.count
  end

  def get_image
    image.attached? ? url_for(image) : ActionController::Base.helpers.asset_path("survey.png")
  end

  def delete_answers
    Survey::Answer.delete_all
    Survey::AnsweredTime.delete_all
    Survey::AnsweredForm.delete_all
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
