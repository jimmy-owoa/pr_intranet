class Location::Country < ApplicationRecord
  resourcify
  validates :name, case_sensitive: false
  has_many :users, class_name: "General::User", foreign_key: :country_id
  has_many :requests, class_name: "ExpenseReport::Request", foreign_key: :country_id

  def self.set_office_country(user, office_country)
    location_country = self.where(name: office_country).first_or_create
    user.country = location_country
    user.save
  end

  def assistants
    General::User.joins(:roles).where(roles: {resource_type: "Location::Country", resource_id: self.id})
   end
end
