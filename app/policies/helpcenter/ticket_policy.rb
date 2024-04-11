class Helpcenter::TicketPolicy < ApplicationPolicy
  def show?
    true
    # user.has_role?(record.subcategory.category.name, record.subcategory.category) || user.has_role?(:admin)
  end
end
