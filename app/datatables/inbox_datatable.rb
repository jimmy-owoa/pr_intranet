class InboxDatatable < ApplicationDatatable
    delegate :admin_expense_report_request_path, to: :@view
  
    private
  
    def data
      requests.map do |request|
          links = []
          links << link_to('ver', admin_expense_report_request_path(request), class: 'btn btn-success btn-sm')

          status = case request.request_state.code
          when 'atendiendo'
            "<p class='text-light bg-primary rounded text-center'>Atendiendo</p>"
          when 'resuelto'
            "<p class='text-light bg-success rounded text-center'>Resuelto</p>"
          when 'enviado'
            "<p class='text-light bg-secondary rounded text-center'>enviado</p>"
          when 'abierto'
            "<p class='text-light bg-warning rounded text-center'>abierto</p>"
          when 'en revisión'
            "<p class='text-light bg-warning rounded text-center'>en revisión</p>"
          when 'borrador'
            "<p class='text-light bg-danger rounded text-center'>borrador</p>"
          when 'aprobado'
            "<p class='text-light bg-success rounded text-center'>aprobado</p>"
          end
          
          {
            id: request.id,
            user: General::User.with_deleted.find(request.user_id).name,
            office: request.user.try(:country).try(:name),
            status: status,
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
        requests = ExpenseReport::Request.where.not(request_state_id: ExpenseReport::RequestState.find_by(name: 'draft').id).where(assistant: @view.current_user)
      else
        requests_country = []
        roles_countries = @view.current_user.roles.where(resource_type: "Location::Country")
        roles_countries.map do |r|
          requests_country << r.resource.requests
        end
        requests_country = ExpenseReport::Request.where(id: requests_country.map {|r| r.ids}, assistant: current_user)
        ids_status = [ExpenseReport::RequestState.find_by(name: 'envoy').id, ExpenseReport::RequestState.find_by(name: 'draft').id]
        requests = requests_country.where.not(request_state_id: ids_status).where(assistant: @view.current_user).order("#{sort_column} #{sort_direction}")
      end

      requests = requests.where(request_state_id: params[:status]) if params[:status].present?

       if sort_column.present? && sort_column == 'user'
         requests = requests.joins(:user).order("name #{sort_direction}")
       else
         requests = requests.order("#{sort_column} #{sort_direction}")
       end
      requests = requests.page(page).per(per_page)
  
      if params[:search][:value].length > 1
        
      end
      requests
    end
  
    def columns
      %w(id user subcategory status total_time time_worked actions)
    end
  end