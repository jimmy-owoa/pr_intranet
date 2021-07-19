class Marketplace::ProductPolicy < ApplicationPolicy

  def destroy?
    user.has_role? :admin
  end

  def update?
    user.has_role? :admin
  end

  def edit?
    user.has_role? :admin
  end

  private

  def product
    record
  end

end
