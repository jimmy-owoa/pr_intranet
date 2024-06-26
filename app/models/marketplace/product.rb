class Marketplace::Product < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActiveModel::Dirty
  has_many_attached :images
  # validate :correct_image_type
  
  has_many :product_term_relationships, -> { where(object_type: "Marketplace::Product") },
           class_name: "General::TermRelationship", foreign_key: :object_id, inverse_of: :product
  has_many :terms, through: :product_term_relationships
  belongs_to :user, class_name: "General::User", optional: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }


  # before_save :update_published_date

  scope :show_product, -> { where(approved: true) }
  scope :approved_and_not_expired, -> { where(approved: true).where(is_expired: false) }

  PRODUCT_TYPE = ["Autos", "Propiedades", "Servicios", "Varios"]
  CURRENCY = ["$", "UF"]

  def self.no_approved
    where(approved: false)
  end

  def self.approved
    where(approved: true)
  end

  def thumb(img)
    img.variant(resize: "60x60>").processed
  end

  def update_published_date
    if self.approved_changed?
      self.published_date = self.approved ? Date.today : nil
    end
  end

  def self.get_filtered(is_approved)
    if is_approved == "true"
      Marketplace::Product.where(approved: true)
    elsif is_approved == "false"
      Marketplace::Product.where(approved: false)
    else
      Marketplace::Product.all
    end
  end

  def permitted_images
    images.attachments.where(permission: 1)
  end

  def unpermitted_images
    images.attachments.where(permission: 0)
  end

  def get_main_image(is_user_product = false)
    default_image = "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png"

    if is_user_product
      # return default_image if !self.images.present?
      url_for(images.first.variant(combine_options: { resize: "400>x300>", gravity: "Center" })) rescue default_image
    else
      # return default_image if self.permitted_images.empty?
      url_for(permitted_images.first.variant(combine_options: { resize: "400>x300>", gravity: "Center" })) rescue default_image
    end
  end

  def default_images
    [{
      src: "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
      thumbnail: "https://intranet-security-assets.s3.us-east-2.amazonaws.com/noimage.png",
    }]
  end

  def get_images(is_user_product = false)
    items = []

    if is_user_product
      self.images.each do |image|
        items << {
          src: url_for(image.variant(combine_options: { resize: "600x400>", gravity: "Center" })),
          thumbnail: url_for(image.variant(resize: "100x100")),
        }
      end
    else
      self.permitted_images.each do |image|
        items << {
          src: url_for(image.variant(combine_options: { resize: "600x400>", gravity: "Center" })),
          thumbnail: url_for(image.variant(resize: "100x100")),
        }
      end
    end

    items
  end


  private

  def correct_image_type
    if images.attached?
      # images.each do |image|
      #   if !image.content_type.in?(%w(image/jpeg image/png))
      #     errors.add(:product, 'El archivo debe ser de tipo imagen (JPEG o PNG)')
      #   end
      # end
    end
  end
end
