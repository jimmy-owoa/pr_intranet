class Media::Gallery < ApplicationRecord
  searchkick match: :word, searchable: [:name]
  belongs_to :post, class_name: "News::Post", optional: true
  has_many :gallery_relations, class_name: "Media::GalleryRelation"
  has_many :attachments, through: :gallery_relations
  validates :name, presence: true
end
