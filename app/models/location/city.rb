class Location::City < ApplicationRecord
  has_many :communes, class_name: 'Location::Commune', foreign_key: :city_id

  belongs_to :region, class_name: 'Location::Region', foreign_key: :region_id, optional: true
end
