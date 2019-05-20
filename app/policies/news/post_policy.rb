class News::PostPolicy < ApplicationPolicy

  def destroy?
    user.has_role? :super_admin or user.has_role? :post_admin or user == post.user
  end

  def update?
    user.has_role? :super_admin or user.has_role? :post_admin or user == post.user
  end

  def edit?
    user.has_role? :super_admin or user.has_role? :post_admin or user == post.user
  end

  def create?
    user.has_role? :super_admin or user.has_role? :post_admin or user == post.user
  end

  private

  def post
    record
  end

end
