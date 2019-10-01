class Company::Office < ApplicationRecord
  has_many :users, class_name: 'General::User', foreign_key: :office_id, inverse_of: :office
  
  belongs_to :commune, class_name: 'Location::Commune', foreign_key: :commune_id, optional: true
end