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

        sla_compliance = if ticket.meets_sla?
          "<p class='text-light bg-success rounded text-center p-1'>Cumple SLA</p>"
        else
          "<p class='text-light bg-warning rounded text-center p-1'>No cumple SLA</p>"
        end

        {
          id: ticket.id,
          requested_position_title: ticket.requested_position_title.gsub('_', ' ').capitalize,
          number_of_vacancies: ticket.number_of_vacancies,
          request_date: ticket.request_date.strftime('%d %m %Y'),
          user: General::User.with_deleted.find(ticket.user_id)&.full_name,
          resolutor: ticket.assistant&.full_name || "Sin Resolutor",
          status: status,
          time_worked: ticket.time_worked,
          total_time: ticket.total_time,
          sla_compliance: sla_compliance,
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
    if @view.current_user.is_admin? || @view.current_user.is_resolutor?
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
      tickets = tickets.joins(:user, :subcategory).where("LOWER(general_users.name) LIKE ? OR LOWER(helpcenter_subcategories.name) LIKE ?",
        "%#{params[:search][:value].downcase}%", "%#{params[:search][:value].downcase}%")
    end

    tickets
  end

  def columns
    %w(id user subcategory status total_time time_worked actions)
  end
end