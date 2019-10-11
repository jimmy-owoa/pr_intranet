class General::Notification < ApplicationRecord
  belongs_to :user
  belongs_to :message, optional: true
end