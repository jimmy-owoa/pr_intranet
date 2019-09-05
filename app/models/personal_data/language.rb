class PersonalData::Language < ApplicationRecord
  has_many :language_levels, class_name: 'PersonalData::LanguageLevel', foreign_key: :language_id
  has_many :users, through: :language_levels
end
