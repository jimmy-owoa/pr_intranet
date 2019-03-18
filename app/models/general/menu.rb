class General::Menu < ApplicationRecord
  searchkick text_middle: [:title, :link]

  has_many :menu_term_relationships, -> {where(object_type: 'General::Menu')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :menu

  has_many :terms, through: :menu_term_relationships

  accepts_nested_attributes_for :terms

  #cache menu and relationships
  def self.menu_cached
    Rails.cache.fetch('General::Menu.all', expires_in: 30.minute) { all.to_a }
  end

  def cached_categories
    Rails.cache.fetch([:terms, object_id, :name], expires_in: 30.minutes) do
      terms.categories.map(&:name)
    end  
  end

  def cached_tags
    Rails.cache.fetch([:terms, object_id, :name], expires_in: 30.minutes) do
      terms.tags.map(&:name)
    end  
  end

end