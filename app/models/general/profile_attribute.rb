class General::ProfileAttribute < ApplicationRecord
  belongs_to :profile, class_name: 'General::Profile', foreign_key: :profile_id, inverse_of: :profile_attributes
end
