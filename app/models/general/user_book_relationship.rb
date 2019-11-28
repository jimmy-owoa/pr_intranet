class General::UserBookRelationship < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: "General::User"
  belongs_to :book, foreign_key: :book_id, class_name: "Library::Book"
end
