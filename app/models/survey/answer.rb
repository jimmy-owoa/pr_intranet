class Survey::Answer < ApplicationRecord
    belongs_to :option, optional: true
    belongs_to :question, optional: true
    belongs_to :user, class_name: 'General::User', optional: true
end
