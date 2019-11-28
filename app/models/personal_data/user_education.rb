class PersonalData::UserEducation < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: "General::User"
  belongs_to :education_state, foreign_key: :education_state_id, class_name: "PersonalData::EducationState"
  belongs_to :education_institution, foreign_key: :education_institution_id, class_name: "PersonalData::EducationInstitution"
end
