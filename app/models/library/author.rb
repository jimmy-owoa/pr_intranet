class Library::Author < ApplicationRecord
    has_many :books, class_name: "Library::Book"
end
