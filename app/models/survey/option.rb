class Survey::Option < ApplicationRecord
  has_many :answers

  belongs_to :question, class_name: "Survey::Question", foreign_key: :question_id, optional: true
end
