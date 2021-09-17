class PersonalData::LanguageLevel < ApplicationRecord
  has_many :user_languages, class_name: "PersonalData::UserLanguage", foreign_key: :language_level_id
  has_many :languages, through: :user_languages
  has_many :users, through: :user_languages
end
