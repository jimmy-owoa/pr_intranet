class Survey::Question < ApplicationRecord
  has_many :answers
  has_many :options, class_name: "Survey::Option"

  belongs_to :survey, optional: true
  after_create :create_option

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |att| att["title"].blank? }

  QUESTION_TYPE = ["Múltiple", "Simple", "Verdadero o Falso", "Texto", "Número", "Selección", "Escala lineal", "Cargas Múltiple", "Cargas Simple","Hijos"]

  def create_option
    if question_type == "Verdadero o Falso"
      Survey::Option.create(title: "Verdadero", question_id: id)
      Survey::Option.create(title: "Falso", question_id: id)
    end
  end
end
