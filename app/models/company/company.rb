class Company::Company < ApplicationRecord
    has_many :users, class_name: 'General::User', foreign_key: :company_id, inverse_of: :company
end
