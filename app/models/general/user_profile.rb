class General::UserProfile < ApplicationRecord
  belongs_to :user, class_name: "General::User", inverse_of: :user_profiles, optional: true
  belongs_to :profile, class_name: "General::Profile", inverse_of: :user_profiles, optional: true
end