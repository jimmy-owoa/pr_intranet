class General::Term < ApplicationRecord
  validates :name, uniqueness: true
  validates_presence_of :name, uniqueness: true
  validates_presence_of :term_type_id

  has_many :post_term_relationships,-> {where(object_type: 'General::Post')}, class_name: 'General::TermRelationship'
  has_many :posts, through: :post_term_relationships
  has_many :attachment_term_relationships,-> {where(object_type: 'General::Attachment')}, class_name: 'General::TermRelationship'
  has_many :attachments, through: :attachment_term_relationships
  has_many :products, through: :product_term_relationships
  has_many :product_term_relationships, through: :product_term_relationships
  
  belongs_to :term_type, class_name: 'General::TermType', optional: true

  PERMISSION = {'excluding' => 'Excluyente', 'including' => 'Incluyente'}

  scope :tags, -> { where(term_type: General::TermType.tag) }
  scope :categories, -> { where(term_type: General::TermType.category) }
  scope :inclusive_tags, -> { where(term_type: General::TermType.tag, permission: 'including') }
  scope :excluding_tags, -> { where(term_type: General::TermType.tag, permission: 'excluding') }
end
