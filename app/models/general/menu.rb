class General::Menu < ApplicationRecord
  searchkick text_middle: [:title, :link]

  has_many :menu_term_relationships, -> {where(object_type: 'General::Menu')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :menu

  has_many :terms, through: :menu_term_relationships

  accepts_nested_attributes_for :terms
end