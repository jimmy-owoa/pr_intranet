class ExpenseReport::Invoice < ApplicationRecord

  # Relations
  belongs_to :request, class_name: "ExpenseReport::Request", optional: :true
  belongs_to :subcategory, class_name: "ExpenseReport::Subcategory"

  has_one_attached :file

end
