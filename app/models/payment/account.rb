class Payment::Account < ApplicationRecord
  belongs_to :user, class_name: 'General::User'

  def filtered_account
    self.account_number = "X" * (self.account_number.length - 4) + self.account_number.last(4)
    self
  end
end
