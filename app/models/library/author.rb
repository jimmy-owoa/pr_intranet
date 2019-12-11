class Library::Author < ApplicationRecord
    has_many :books, class_name: "Library::Book"

    validates :name, presence: true, uniqueness: { case_sensitive: false }
end
