class PersonalData::Language < ApplicationRecord
  has_many :user_languages, class_name: "PersonalData::UserLanguage", foreign_key: :language_id
  has_many :language_levels, through: :user_languages
  has_many :users, through: :user_languages
end
