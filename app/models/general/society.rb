class General::Society < ApplicationRecord
    validates :name, presence: true
    has_many :requests, class_name: 'ExpenseReport::Request', foreign_key: :society_id
end
