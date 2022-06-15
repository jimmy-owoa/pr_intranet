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
            category: request.subcategory.present? ? request.subcategory.category.name : 'sin categoria',
            subcategory: request.subcategory.present? ? request.subcategory.name : 'sin subcategoria',
            office: request.user.country.name,
            status: request.request_state.code,
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
        requests = ExpenseReport::Request.all.order(created_at: :desc)
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