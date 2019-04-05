class Marketplace::Product < ApplicationRecord
  include ActiveModel::Dirty
  has_many_attached :images
  has_many :product_term_relationships, -> {where(object_type: 'Marketplace::Product')},
  class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :product
  has_many :terms, through: :product_term_relationships
  belongs_to :user, class_name: 'General::User', optional: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :update_published_date

  scope :show_product , -> {where(approved: true)}

  PRODUCT_TYPE = ['Autos','Propiedades', 'Servicios', 'Varios']

  def thumb img
    img.variant(resize: '60x60>').processed
  end

  def update_published_date
    if self.approved_changed?
      self.published_date = self.approved ? Date.today : nil
    end
  end

  def permitted_images
    images.attachments.where(permission: 1)
  end

  def unpermitted_images
    images.attachments.where(permission: 0)
  end
  
end
