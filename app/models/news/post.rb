class News::Post < ApplicationRecord
  acts_as_paranoid
  searchkick match: :word, searchable: [:title, :slug, :content]

  has_many :comments, class_name: 'News::Comment'
  has_many :post_term_relationships, -> {where(object_type: 'News::Post')},
            class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :post_term_relationships
  has_many :attachments, as: :attachable
  has_and_belongs_to_many :galleries, class_name: 'General::Gallery'
  belongs_to :post_parent, class_name: 'News::Post', optional: true
  belongs_to :main_image, class_name: 'General::Attachment', optional: true
  belongs_to :user, class_name: 'General::User', optional: true

  accepts_nested_attributes_for :terms

  after_initialize :set_status

  STATUS = ['Publicado','Borrador', 'Programado']
  VISIBILITY = ['Público', 'Privada']
  FORMAT = {0 => 'Estilo 1', 1 => 'Estilo 2', 2 => 'Estilo 3'}

  def set_status
    self.status ||= 'Publicado'
  end
end
