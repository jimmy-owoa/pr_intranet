class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :image

  has_many :questions, if: -> { is_show? }
  attribute :breadcrumbs, if: -> { is_show? }

  def image
    object.get_image
  end

  def breadcrumbs
    [
      { to: "/", text: "Inicio", disabled: false, exact: true },
      { to: "/encuestas", text: "Encuestas", disabled: false, exact: true },
      { to: "", text: object.name.truncate(30), disabled: true },
    ]
  end

  def is_show?
    instance_options[:is_show]
  end
end