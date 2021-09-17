class PersonalData::UserLanguage < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: "General::User"
  belongs_to :language, foreign_key: :language_id, class_name: "PersonalData::Language"
  belongs_to :language_level, foreign_key: :language_level_id, class_name: "PersonalData::LanguageLevel"
end
