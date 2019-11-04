class Location::Commune < ApplicationRecord
  has_many :home_addresses, class_name: "PersonalData::HomeAddress", foreign_key: :commune_id
  belongs_to :city, class_name: "Location::City", foreign_key: :city_id, optional: true
end
