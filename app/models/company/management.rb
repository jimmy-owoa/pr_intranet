class Company::Management < ApplicationRecord
  has_many :users, class_name: "General::User", foreign_key: :management_id, inverse_of: :management
end
