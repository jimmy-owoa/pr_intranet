class Marketplace::Product < ApplicationRecord
  has_many_attached :images
  has_many :product_term_relationships, -> {where(object_type: 'Marketplace::Product')},
  class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :product
  has_many :terms, through: :product_term_relationships
  belongs_to :user, class_name: 'General::User', optional: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :show_product , -> {where( approved: true)}

  PRODUCT_TYPE = ['Autos','Propiedades', 'Servicios', 'Varios']

  def thumb img
    img.variant(resize: '120x120>').processed
  end

  # def medium(image)
  #   return image.variant(resize: '300x300>').processed
  # end

  # def large(image)
  #   return image.variant(resize: '1000x400>').processed
  # end
end
