class General::UserAttribute < ApplicationRecord
  belongs_to :user, class_name: "General::User", foreign_key: :user_id, inverse_of: :user_attributes
end
