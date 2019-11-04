class PersonalData::FamilyMember < ApplicationRecord
  belongs_to :user, class_name: "General::User", foreign_key: :user_id
end
