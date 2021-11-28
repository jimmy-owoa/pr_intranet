class Helpcenter::Category < ApplicationRecord
  include Rails.application.routes.url_helpers
  # rolify
  resourcify
  #validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  # Relations
  belongs_to :profile, class_name: 'General::Profile'
  has_many :subcategories ,class_name: 'Helpcenter::Subcategory', foreign_key: :category_id, dependent: :destroy, inverse_of: :category
  accepts_nested_attributes_for :subcategories, allow_destroy: true, reject_if: proc { |att| att['name'].blank? }
  # Active storage
  has_one_attached :image

  before_save :unique_slug

  def assistants
    General::User.joins(:roles).where(roles: {resource_type: "Helpcenter::Category", resource_id: self.id})
  end

  def unique_slug
    self.slug = slug.blank? ? set_slug(name.parameterize) : set_slug(name.parameterize)
  end

  def set_slug(val)
    category_by_slug = Helpcenter::Category.find_by(slug: val)
    if category_by_slug.present? && category_by_slug != self
      random_number = rand(1000..9999)
      slug_split = val.split('-')
      if slug_split[-1].match?(/^[0-9]+$/)
        temp = if slug_split.count > 1
                 slug_split[0..-2].join('-')
               else
                 slug_split[0]
               end
        set_slug(temp + '-' + random_number.to_s)
      else
        set_slug(val + '-' + random_number.to_s)
      end
    else
      val
    end
  end

  def get_image
    image.attached? ? url_for(image) : ""
  end
end
