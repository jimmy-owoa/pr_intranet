class Helpcenter::Question < ApplicationRecord
  # validations
  validates :name, :subcategory_id, presence: true
  # relations
  belongs_to :subcategory, class_name: 'Helpcenter::Subcategory'

  def self.important_questions(current_user)
    questions = Helpcenter::Question.where(important: true).order(:created_at)
    data = []
    questions.each do |question|
      next unless question.subcategory.category.profile_id.in?(current_user.profile_ids)
      data << question
    end
    data.first(5)
  end
end
