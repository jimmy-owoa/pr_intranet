class ExpenseReport::Category < ApplicationRecord
  #validations
  validates :name, presence: true
  validates :name, case_sensitive: false

  # Relations
  has_many :subcategories ,class_name: 'ExpenseReport::Subcategory', foreign_key: :category_id, dependent: :destroy, inverse_of: :category
  accepts_nested_attributes_for :subcategories, allow_destroy: true, reject_if: proc { |att| att['name'].blank? }
  
end
