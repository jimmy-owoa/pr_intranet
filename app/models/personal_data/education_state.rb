class PersonalData::EducationState < ApplicationRecord
  has_many :user_educations, class_name: "PersonalData::UserEducation", foreign_key: :education_state_id
  has_many :education_institutions, through: :user_educations
  has_many :users, through: :user_educations
end
