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
            office: request.user.country.name,
            status: request.request_state.present? ? request.request_state.code : '',
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
        requests = ExpenseReport::Request.all.order(created_at: :desc)
      else
        requests_country = []
        roles_countries = @view.current_user.roles.where(resource_type: "Location::Country")
        roles_countries.map do |r|
          requests_country << r.resource.requests
        end
        requests_country = ExpenseReport::Request.where(id: requests_country.map {|r| r.ids})
        requests = requests_country.where.not(request_state_id: ExpenseReport::RequestState.find_by(code: 'enviado').id).order(created_at: :desc)

      end
      requests = requests.where(request_state_id: params[:status]) if params[:status].present?
      requests = requests.page(page).per(per_page)
  
      if params[:search][:value].length > 1
        
      end
      requests
    end
  
    def columns
      %w(id user subcategory status total_time time_worked actions)
    end
  end