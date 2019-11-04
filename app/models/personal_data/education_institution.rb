class PersonalData::EducationInstitution < ApplicationRecord
  has_many :education_states, class_name: "PersonalData::EducationState", foreign_key: :education_state_id
  has_many :users, through: :education_states
end
