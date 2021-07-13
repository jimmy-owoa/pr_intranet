class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :image

  has_many :questions, if: -> { is_show? }

  def image
    object.get_image
  end

  def is_show?
    instance_options[:is_show]
  end
end