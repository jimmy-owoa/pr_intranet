class Helpcenter::TicketPolicy < ApplicationPolicy
  def show?
    user.has_role?(record.subcategory.category.name, record.subcategory.category) || user.has_role?(:admin)
  end
end
