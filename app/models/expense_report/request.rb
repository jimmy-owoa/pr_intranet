class ExpenseReport::Request < ApplicationRecord
  #validations
  validates :description, presence: true

  # Relations
  belongs_to :user, class_name: "General::User"
  belongs_to :subcategory, class_name: "ExpenseReport::Subcategory"
  belongs_to :society, class_name: "General::Society"
  has_many :request_histories, class_name: "ExpenseReport::RequestHistory", foreign_key: :request_id
  has_many :invoices, class_name: "ExpenseReport::Invoice", foreign_key: :request_id
end
