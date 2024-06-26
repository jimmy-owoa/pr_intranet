class Library::Book < ApplicationRecord
  belongs_to :author, class_name: "Library::Author"
  belongs_to :editorial, class_name: "Library::Editorial"
  belongs_to :category_book, class_name: "Library::CategoryBook"
  has_many :user_book_relationships, class_name: "General::UserBookRelationship", foreign_key: :book_id
  has_many :users, -> { distinct }, through: :user_book_relationships

  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  validates :author, presence: true
  validates :editorial, presence: true
  validates :category_book, presence: true
  validates :stock, presence: true
  validates :image, presence: true

  scope :available_books, -> { where(available: true) }
end
