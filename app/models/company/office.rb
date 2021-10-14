class Company::Office < ApplicationRecord
  belongs_to :commune, class_name: "Location::Commune", foreign_key: :commune_id, optional: true
end
