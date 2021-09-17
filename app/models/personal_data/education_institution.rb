class PersonalData::EducationInstitution < ApplicationRecord
  has_many :user_educations, class_name: "PersonalData::UserEducation", foreign_key: :education_institution_id
  has_many :education_states, through: :user_educations
  has_many :users, through: :user_educations
end
