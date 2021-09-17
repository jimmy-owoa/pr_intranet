class Survey::AnsweredForm < ApplicationRecord
  belongs_to :survey
  belongs_to :user, class_name: 'General::User'
  has_many :answers
end
