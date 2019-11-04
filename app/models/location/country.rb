class Location::Country < ApplicationRecord
  has_many :regions, class_name: "Location::Region", foreign_key: :country_id
end
