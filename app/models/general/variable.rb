class General::Variable < ApplicationRecord
  belongs_to :general_benefit, class_name: "General::Benefit", optional: true
end
