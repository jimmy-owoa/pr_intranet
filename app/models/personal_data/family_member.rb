class PersonalData::FamilyMember < ApplicationRecord
  belongs_to :user, class_name: "General::User"
end
