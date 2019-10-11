class General::ObjectProfile < ApplicationRecord
  belongs_to :profile, class_name: "General::Profile", foreign_key: :profile_id, inverse_of: :object_profiles
end
