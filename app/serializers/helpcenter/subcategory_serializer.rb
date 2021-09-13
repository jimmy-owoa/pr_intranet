class Helpcenter::SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  attribute :breadcrumbs, if: -> { is_show? }
  attribute :questions, if: -> { is_show? }

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { to: "/#{object.category.slug}", text: "#{object.category.name}", disabled: false, exact: true },
      { to: "", text: object.name.truncate(30), disabled: true },
    ]
  end

  def questions
    object.questions.map do |question|
      Helpcenter::QuestionSerializer.new(question)
    end
  end

  def is_show?
    instance_options[:is_show]
  end
end
