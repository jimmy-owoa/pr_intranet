class Survey::Question < ApplicationRecord
    has_many :answers
    has_many :options, class_name: 'Survey::Option'

    belongs_to :survey, optional: true

    accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |att| att['title'].blank?}

    QUESTION_TYPE = ['Múltiple','Simple', 'Verdadero o Falso', 'Texto', 'Número']

end
