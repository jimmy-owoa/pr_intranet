class General::Term < ApplicationRecord
  validates :name, uniqueness: true

  has_many :post_term_relationships,-> {where(object_type: 'General::Post')}, class_name: 'General::TermRelationship'
  has_many :posts, through: :post_term_relationships
  has_many :attachment_term_relationships,-> {where(object_type: 'General::Attachment')}, class_name: 'General::TermRelationship'
  has_many :attachments, through: :attachment_term_relationships
  has_many :products, through: :product_term_relationships
  has_many :product_term_relationships, through: :product_term_relationships



  belongs_to :term_type, class_name: 'General::TermType', optional: true

  scope :tags, -> { where(term_type: General::TermType.tag) }
  scope :categories, -> { where(term_type: General::TermType.category) }
end
