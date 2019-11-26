class Library::Editorial < ApplicationRecord
    has_many :books, class_name: "Library::Book"
end
