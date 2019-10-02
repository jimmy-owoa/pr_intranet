class General::UserMessage < ApplicationRecord
  belongs_to :user, class_name: "General::User", inverse_of: :user_messages, optional: true
  belongs_to :message, class_name: "General::Message", inverse_of: :user_messages, optional: true
end