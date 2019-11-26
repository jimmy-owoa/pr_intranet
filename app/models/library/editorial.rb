class Library::Editorial < ApplicationRecord
    has_many :book_editorial_relationships, class_name: "Library::BookEditorialRelationship", foreign_key: :editorial_id
    has_many :books, -> { distinct }, through: :book_editorial_relationships
end
