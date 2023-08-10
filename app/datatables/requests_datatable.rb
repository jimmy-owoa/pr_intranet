class RequestsDatatable < ApplicationDatatable
    delegate :admin_expense_report_request_path, to: :@view
  
    private
  
    def data
      requests.map do |request|
          links = []
          links << link_to('ver', admin_expense_report_request_path(request), class: 'btn btn-success btn-sm')
          {
            id: request.id,
            user: General::User.with_deleted.find(request.user_id).full_name,
            office: request.user.try(:country).try(:name),
            society_id: request.society.present? ? request.society.name : 'No definido',
            assistant_id: request.assistant_id.present? ? General::User.find(request.assistant_id).full_name : 'No definido',
            status: request.status_color,
            divisa: request.divisa_id.nil? ? 'No definido' : request.divisa_id,
            total_time: request.total_time,
            time_worked: request.time_worked,
            actions: links.join(' ')
          }
      end
    end
  
    def count
      ExpenseReport::Request.count
    end
  
    def total_entries
      requests.total_count
    end
  
    def requests
      @requests ||= fetch_requests
    end
  
    def fetch_requests
      if @view.current_user.is_admin?
        requests = ExpenseReport::Request.with_deleted.where.not(request_state_id: ExpenseReport::RequestState.find_by(name: 'draft').id)
      else
        roles_countries = @view.current_user.roles.where(resource_type: "Location::Country").pluck(:resource_id)
        requests = ExpenseReport::Request.includes(:request_state).with_deleted.where(country_id: roles_countries).where.not(expense_report_request_states: { name: ['draft', 'envoy'] })
      end
      
      if sort_column.present? && sort_column == 'user'
        requests = requests.joins(:user).order("name #{sort_direction}")
      elsif sort_column == 'office'
        requests = requests.joins(user: :country).order("location_countries.name #{sort_direction}")
      elsif sort_column == 'id'
        requests = requests.order("expense_report_requests.id #{sort_direction}")
      else
        requests = requests.order("#{sort_column} #{sort_direction}")
      end

      if params[:search][:value].length > 1
        requests = requests.left_outer_joins(:user, :society, :country, :request_state, :assistant)
        .where("expense_report_requests.id LIKE :search OR LOWER(general_users.name) LIKE :search OR LOWER(general_users.last_name) LIKE :search OR LOWER(general_societies.name) LIKE :search OR location_countries.name LIKE :search OR expense_report_request_states.code LIKE :search OR LOWER(assistants_expense_report_requests.name) LIKE :search OR LOWER(assistants_expense_report_requests.last_name) LIKE :search",
        search: "%#{params[:search][:value].downcase}%")
      end

      requests = requests.where(request_state_id: params[:status]) if params[:status].present?
      requests = requests.page(page).per(per_page)
  


      requests
    end
  
    def columns
      %w(id user office society_id assistant_id request_state_id divisa_id total_time time_worked actions)
    end
  end