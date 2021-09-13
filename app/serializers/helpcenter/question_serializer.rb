class Helpcenter::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :url
  attribute :breadcrumbs, if: -> { is_show? }

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { 
        to: "/#{object.subcategory.category.slug}", 
        text: "#{object.subcategory.category.name}", 
        disabled: false, 
        exact: true 
      },
      { 
        to: "/#{object.subcategory.category.slug}/#{object.subcategory.slug}", 
        text: "#{object.subcategory.name.truncate(30)}", 
        disabled: false,
        exact: true
      },
      { to: "", text: object.name.truncate(30), disabled: true },
    ]
  end

  def url
    "/#{object.subcategory.category.slug}/#{object.subcategory.slug}/#{object.id}"
  end

  def is_show?
    instance_options[:is_show]
  end
end