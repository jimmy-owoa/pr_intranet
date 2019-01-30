class Survey::Answer < ApplicationRecord
  belongs_to :option, optional: true
  belongs_to :question, optional: true
  belongs_to :user, class_name: 'General::User', optional: true
  before_save :set_question_id

  validate :already_answered

  def already_answered
    Survey::Answer.where(user_id: user_id, question_id: question_id, option_id: option_id).blank?
  end

  def set_question_id
    self.question_id ||= Survey::Option.find(option_id).question_id 
  end
end
