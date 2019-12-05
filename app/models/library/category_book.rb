class Library::CategoryBook < ApplicationRecord
  has_many :books, class_name: "Library::Book"

  validates :name, presence: true
end
