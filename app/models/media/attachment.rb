class Media::Attachment < ApplicationRecord
  has_many :posts_main_image, class_name: "News::Post", foreign_key: :main_image_id
  has_many :gallery_relations, class_name: "Media::GalleryRelation"
  has_many :galleries, through: :gallery_relations
  belongs_to :attachable, polymorphic: true, optional: true
  has_many :posts_video, class_name: "News::Post", foreign_key: :file_video_id

  has_one_attached :attachment

  before_save :default_name

  scope :videos, -> { where("attachment.content_type LIKE ? ", "%video%") }
  scope :images, -> { where("attachment.content_type LIKE ? ", "%image%") }

  def default_name
    if self.attachment.attached?
      self.name = self.name || self.attachment.attachment.filename.to_s
    end
  end

  def thumb
    if self.attachment.attached?
      begin
        return self.attachment.variant(resize: "120x120>").processed
      rescue
        if self.attachment.content_type == "text/plain"
          return nil
        end
      end
    end
  end

  def medium
    begin
      return self.attachment.attachment.variant(resize: "300x300>").processed
    rescue
      return nil
    end
  end

  def large
    begin
      return self.attachment.attachment.variant(resize: "1000x400>").processed
    rescue
      return nil
    end
  end

  def self.images
    Media::Attachment.joins(:attachment_blob).where("content_type LIKE ?", "%image%")
  end

  def self.videos
    Media::Attachment.joins(:attachment_blob).where("content_type LIKE ?", "%video%")
  end
end
