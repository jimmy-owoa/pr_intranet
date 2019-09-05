class Location::Region < ApplicationRecord
  has_many :cities, class_name: 'Location::City', foreign_key: :region_id

  belongs_to :country, class_name: 'Location::Country', foreign_key: :country_id
end
