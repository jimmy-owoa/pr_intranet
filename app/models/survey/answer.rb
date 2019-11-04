class Survey::Answer < ApplicationRecord
  belongs_to :option, optional: true
  belongs_to :question, optional: true
  belongs_to :user, class_name: "General::User", optional: true

  def set_question_id
    self.question_id ||= Survey::Option.find(option_id).question_id
  end
end
