class General::Attachment < ApplicationRecord
  after_create :path
  has_one_attached :attachment

  has_many :posts_main_image, class_name: 'News::Post', foreign_key: :main_image_id
  has_many :attachment_term_relationships, -> {where(object_type: 'General::Attachment')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :attachment
  has_many :terms, through: :attachment_term_relationships
  has_many :gallery_relations, class_name: 'General::GalleryRelation'
  has_many :galleries, through: :gallery_relations

  belongs_to :attachable, polymorphic: true, optional: true

  def thumb
    begin 
      return self.attachment.variant(resize: '120x120>').processed
    rescue
      if self.attachment.content_type == 'text/plain'
        return nil
      end
    end
  end

  def medium
    begin
    return self.attachment.attachment.variant(resize: '300x300>').processed
    rescue
      return nil
    end
  end

  def large
    begin
      return self.attachment.attachment.variant(resize: '1000x400>').processed
    rescue
      return nil
    end
  end
end





# Upload an image by rails console
# News::Attachment.first.main_image.attach(io: File.open("app/assets/images/libro.jpg"), filename: "libro.jpg", content_type: "image/jpg")
