class General::Society < ApplicationRecord
    # include Rails.application.routes.url_helpers
    validates :name, presence: true
    has_many :requests, class_name: 'ExpenseReport::Request', foreign_key: :society_id
    has_many :users, class_name: 'General::User', foreign_key: :society_id
end
