class Helpcenter::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :image
  attribute :breadcrumbs, if: -> { is_show? }
  attribute :subcategories
  # has_many :subcategories

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { to: "", text: object.name.truncate(30), disabled: true },
    ]
  end

  def subcategories
    object.subcategories.map do |subcategory|
      {
        id: subcategory.id,
        name: subcategory.name,
        slug: subcategory.slug
      }
    end
  end

  def is_show?
    instance_options[:is_show]
  end

  def image
    object.get_image
  end
end