class General::UserPolicy < ApplicationPolicy

  def new?
    return true if user.has_role? :admin
    false
  end

end