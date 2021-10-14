class Location::Country < ApplicationRecord
  has_many :users, class_name: "General::User", foreign_key: :country_id

  def self.set_office_country(user, office_country)
    location_country = self.where(name: office_country).first_or_create
    user.country = location_country
    user.save
  end
end
