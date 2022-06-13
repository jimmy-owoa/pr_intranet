class Payment::Account < ApplicationRecord
  belongs_to :user, class_name: 'General::User'
end
