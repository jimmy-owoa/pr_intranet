class Marketplace::ProductPolicy < ApplicationPolicy

  def destroy?
    user.has_role? :super_admin or user == product.user
  end

  def update?
    user.has_role? :super_admin or user == product.user
  end

  def edit?
    user.has_role? :super_admin or user == product.user
  end

  private

  def product
    record
  end

end
