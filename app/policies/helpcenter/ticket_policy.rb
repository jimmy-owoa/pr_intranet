class Helpcenter::TicketPolicy < ApplicationPolicy
  def show?
    user.has_role?(record.category.name, record.category) || user.has_role?(:admin)
  end
end
