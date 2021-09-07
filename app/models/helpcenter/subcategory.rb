class Helpcenter::Subcategory < ApplicationRecord
  validates :name, presence: true

  belongs_to :category, class_name: 'Helpcenter::Category'
  has_many :questions, class_name: 'Helpcenter::Question', foreign_key: :subcategory_id

  before_save :unique_slug

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
end
