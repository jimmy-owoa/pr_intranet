class PersonalData::HomeAddress < ApplicationRecord
  belongs_to :commune, class_name: "Location::Commune", foreign_key: :commune_id
end
