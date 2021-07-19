class News::PostPolicy < ApplicationPolicy

  def destroy?
    user.has_role? :super_admin or user.has_role? :admin
  end

  def update?
    user.has_role? :super_admin or user.has_role? :admin
  end

  def edit?
    user.has_role? :super_admin or user.has_role? :admin
  end

  def create?
    user.has_role? :super_admin or user.has_role? :admin 
  end

  private

  def post
    record
  end

end
