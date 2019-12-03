class Library::CategoryBook < ApplicationRecord
  has_many :books, class_name: "Library::Book"
end
