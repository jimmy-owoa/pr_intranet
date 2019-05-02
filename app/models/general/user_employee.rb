class General::UserEmployee < ApplicationRecord
  has_secure_password
  require 'bcrypt'
  before_save :setup

  def setup
    self.password_digest = BCrypt::Password.create(self.password_digest)
  end
  
end
