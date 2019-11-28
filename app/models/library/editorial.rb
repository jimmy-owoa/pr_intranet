class Library::Editorial < ApplicationRecord
    has_many :books, class_name: "Library::Book"

    validates :name, presence: true
end
