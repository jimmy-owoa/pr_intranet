class General::Menu < ApplicationRecord
  searchkick word: [{title: :exact, link: :exact}]

  # validates_presence_of :title
  belongs_to :post, class_name: "News::Post", foreign_key: "post_id", optional: true

  has_many :menu_term_relationships, -> {where(object_type: 'General::Menu')}, class_name: 'General::TermRelationship', foreign_key: :object_id, inverse_of: :menu
  has_many :terms, through: :menu_term_relationships

  scope :parent_name_menu, -> (id) { find(id).title }

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

  def children(integration_menu = nil)
    menus = []
    if integration_menu.present? && integration_menu.key?(self.integration_code) && integration_menu[self.integration_code]["drop_down"].present?
      temp = get_dropdowns(integration_menu[self.integration_code]["drop_down"],menus)
      menus << temp if temp.is_a?(Hash)
    else
      data = General::Menu.where(parent_id: self.id)
      data.each do |menu|
        
        menus << {
          title: menu.title,
          link: menu.link.present? ? menu.link : '',
          menu_id: menu.id,
          post_slug: menu.post.present? ? menu.post.slug : ''
        }
      end
    end
    menus
  end

  def get_dropdowns(dropdown,menus)
    dropdown.each do |key,value|
      if value.is_a?(Hash) && value.key?("drop_down")
        menus << {
          title: value["nombre"],
          link: "",
          menu_id: -1
        }
        get_dropdowns(value,menus)
      elsif value["nombre"].present?
        menus << {
          title: value["nombre"],
          link: "https://misecurity-qa2.exa.cl#{value['link']}",
          menu_id: -1
        }
      end
    end
    menus
  end

end