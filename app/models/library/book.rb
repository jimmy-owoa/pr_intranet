class Library::Book < ApplicationRecord
    belongs_to :author, class_name: "Library::Author"
    has_many :book_editorial_relationships, class_name: "Library::BookEditorialRelationship", foreign_key: :book_id
    has_many :editorials, -> { distinct }, through: :book_editorial_relationships
end
