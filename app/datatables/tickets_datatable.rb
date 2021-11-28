class TicketsDatatable < ApplicationDatatable
  delegate :admin_helpcenter_ticket_path, to: :@view

  private

  def data
    tickets.map do |ticket|
      links = []
      links << link_to('<i class="fas fa-edit"></i> Ver'.html_safe, admin_helpcenter_ticket_path(ticket), class: 'btn btn-success btn-sm')

      {
        id: ticket.id,
        user: ticket.user.full_name,
        subcategory: ticket.subcategory.name,
        status: ticket.status,
        total_time: ticket.total_time,
        time_worked: ticket.time_worked,
        actions: links.join(' ')
      }
    end
  end

  def count
    Helpcenter::Ticket.count
  end

  def total_entries
    tickets.total_count
  end

  def tickets
    @posts ||= fetch_tickets
  end

  def fetch_tickets
    if @view.current_user.is_admin?
      tickets = Helpcenter::Ticket.all.order(created_at: :desc)
    else
      categories = @view.current_user.help_categories
      subcategories = categories.map(&:subcategory_ids).flatten
      tickets = Helpcenter::Ticket.where("subcategory_id in (:subcategory_ids)", subcategory_ids: subcategories)
    end

    tickets = tickets.where(status: params[:status]) if params[:status].present?
    tickets = tickets.page(page).per(per_page)

    if params[:search][:value].length > 1
      
    end

    tickets
  end

  def columns
    %w(id user subcategory status total_time time_worked actions)
  end
end