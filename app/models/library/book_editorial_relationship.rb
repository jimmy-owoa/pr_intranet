class Library::BookEditorialRelationship < ApplicationRecord
  belongs_to :book, foreign_key: :book_id, class_name: "Library::Book"
  belongs_to :editorial, foreign_key: :editorial_id, class_name: "Library::Editorial"
end
