class General::Gallery < ApplicationRecord
  #has_many :attachments, as: :attachable
  has_and_belongs_to_many :posts, class_name: 'News::Post'
  has_many :gallery_relations, class_name: 'General::GalleryRelation'
  has_many :attachments, through: :gallery_relations
  validates :name, presence: true
end
