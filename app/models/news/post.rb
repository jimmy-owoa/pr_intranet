class News::Post < ApplicationRecord
  acts_as_paranoid
  searchkick match: :word, searchable: [:title, :slug, :content]

  has_many :comments, class_name: 'News::Comment'
  has_many :post_term_relationships, -> {where(object_type: 'News::Post')},
            class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :post
  has_many :terms, through: :post_term_relationships
  has_many :attachments, as: :attachable
  has_and_belongs_to_many :galleries, class_name: 'General::Gallery'
  belongs_to :post_parent, class_name: 'News::Post', optional: true
  belongs_to :main_image, class_name: 'General::Attachment', optional: true
  belongs_to :user, class_name: 'General::User', optional: true, touch: true

  accepts_nested_attributes_for :terms

  after_initialize :set_status

  before_save :unique_slug

  scope :important, -> { where(:important => true).last(5)}

  STATUS = ['Publicado','Borrador', 'Programado']
  VISIBILITY = ['Público', 'Privada']
  FORMAT = {0 => 'Estilo 1', 1 => 'Estilo 2', 2 => 'Estilo 3'}
  TYPE = ['Corporativas', 'Miscelaneos', 'Conociéndonos']
  PERMISSION = [
    'Incluyente',
    'Excluyente'
  ]  

  def set_status
    self.status ||= 'Publicado'
  end

  def self.posts_cached
    Rails.cache.fetch('General::Post.includes(:main_image)') { all.to_a }
  end

  def cached_users_names
    Rails.cache.fetch :user_name, :expires_in => 1.days do
      General::User.find(self.user_id).name
    end 
  end

  def cached_tags
    Rails.cache.fetch :tags, :expires_in => 1.days do
      self.terms.tags
    end 
  end

  private

  def unique_slug
    self.slug = if self.slug.blank?
        set_slug(self.title.parameterize)
      else
        set_slug(self.slug.parameterize)
      end
  end

  def set_slug(val)
    post_by_slug = News::Post.find_by(slug: val)
    if post_by_slug.present? && post_by_slug != self
      random_number = rand(1000..9999)
      slug_split = val.split('-')
      if slug_split[-1].match? /^[0-9]+$/
        if slug_split.count > 1
          temp = slug_split[0..-2].join('-')
        else
          temp = slug_split[0]
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
