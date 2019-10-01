class PersonalData::LanguageLevel < ApplicationRecord
  belongs_to :user, class_name: 'General::User', foreign_key: :user_id
  belongs_to :language, class_name: 'PersonalData::Language', foreign_key: :language_id
end
