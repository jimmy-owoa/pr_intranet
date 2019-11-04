class PersonalData::EducationState < ApplicationRecord
  belongs_to :education_institution, class_name: "PersonalData::EducationInstitution", foreign_key: :education_institution_id
  belongs_to :user, class_name: "General::User", foreign_key: :user_id
end
