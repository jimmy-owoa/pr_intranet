class General::UserPolicy < ApplicationPolicy

  def new?
    return true if user.has_role? :super_admin
    false
  end

end