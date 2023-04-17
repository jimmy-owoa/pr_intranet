class ExpenseReport::Invoice < ApplicationRecord

  # Relations
  belongs_to :request, class_name: "ExpenseReport::Request", optional: :true
  belongs_to :category, class_name: "ExpenseReport::Category"
  validates_presence_of :total, :category

  has_many_attached :files
  acts_as_paranoid

end
