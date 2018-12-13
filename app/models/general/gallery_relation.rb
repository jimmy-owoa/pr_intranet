class General::GalleryRelation < ApplicationRecord
  belongs_to :gallery, optional: true
  belongs_to :attachment, optional: true
end
