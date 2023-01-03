class TicketsDatatable < ApplicationDatatable
  delegate :admin_helpcenter_ticket_path, to: :@view

  private

  def data
    tickets.map do |ticket|
        links = []
        links << link_to('<i class="fas fa-edit"></i> Ver'.html_safe, admin_helpcenter_ticket_path(ticket), class: 'btn btn-success btn-sm')

        status = case ticket.status
        when 'open'
          "<p class='text-light bg-danger rounded text-center p-1'>Abierto</p>"
        when 'attended'
          "<p class='text-light bg-primary rounded text-center p-1'>Atendiendo</p>"
        when 'recategorized'
          "<p class='text-black bg-secondary rounded text-center p-1'>Recategorizado</p>"
        when 'closed'
          "<p class='text-light bg-success rounded text-center p-1'>Resuelto</p>"
        when 'waiting'
          "<p class='text-back bg-secondary rounded text-center p-1'>En Espera</p>"
        end

        {
          id: ticket.id,
          user: General::User.with_deleted.find(ticket.user_id).full_name,
          category: ticket.subcategory.present? ? ticket.subcategory.category.name : 'sin categoria',
          subcategory: ticket.subcategory.present? ? ticket.subcategory.name : 'sin subcategoria',
          office: ticket.subcategory.present? ? ticket.subcategory.category.profile.name : '',
          status: status,
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
      tickets = Helpcenter::Ticket.where(aproved_to_review: true)
    else
      categories = @view.current_user.help_categories
      subcategories = categories.map(&:subcategory_ids).flatten
      tickets = Helpcenter::Ticket.where("subcategory_id in (:subcategory_ids)", subcategory_ids: subcategories)
    end

    tickets = tickets.where(status: params[:status]) if params[:status].present?

    if sort_column.present? && sort_column == 'user'
      tickets = tickets.joins(:user).order("name #{sort_direction}")
    else
      tickets = tickets.order("#{sort_column} #{sort_direction}")
    end

    tickets = tickets.page(page).per(per_page)

    if params[:search][:value].length > 1
      
    end

    tickets
  end

  def columns
    %w(id user subcategory status total_time time_worked actions)
  end
end