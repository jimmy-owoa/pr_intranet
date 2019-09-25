class General::TermType < ApplicationRecord
  has_many :terms, class_name: "General::Term"

  scope :category, -> { where(name: "Category").first }
  scope :tag, -> { where(name: "Tag").first }
  scope :product_type, -> { where(name: "product_type").first }
end
