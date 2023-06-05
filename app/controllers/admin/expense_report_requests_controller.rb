module Admin
  class ExpenseReportRequestsController < AdminController

    before_action :set_request, only: [:edit, :show, :destroy, :update, :take_request, :close]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def index
      @status = params[:status]
      @all_status= ExpenseReport::RequestState.where.not(name: ['draft', 'envoy']).map {|status| [status.code, status.id]}

      respond_to do |format|
        format.html
        format.json { render json: RequestsDatatable.new(view_context) }
      end
    end

    def new
    end

    def edit
      #authorize @request, :show?
      @categories = ExpenseReport::Category.all
      @invoices = @request.invoices
      @selected_index = nil
      ExpenseReport::Request::COUNTRY.each_with_index do |country, index|
        if country.first.first.to_s == @request.destination_country_id
          @selected_index = index
          break
        end
      end
    end
    
    def show
      #authorize @request, :show?
      @supervisor = @request.user.get_supervisor_full_name
      @start_chat = params[:start_chat] if params[:start_chat].present?
      @chat_messages = Chat::Room.where(resource_type: 'ExpenseReport::Request', resource_id: @request.id).last.try(:messages) || []
      @payment_date = @request.try(:payment_date).present? ? @request.try(:payment_date).strftime("%d/%m/%Y") : 'Definir fecha de pago'
    end

    def update
      # authorize @request, :show?
      respond_to do |format|
        if @request.update(request_params.merge(destination_country_id: request_params[:destination_country_id].to_i))
          UserNotifierMailer.notification_request_payment_date(@request).deliver if @request.payment_date.present? 
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "request fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @request }
        end
      end
    end
    
    def destroy
      @request.request_histories.each {|h| h.destroy}
      @request.invoices.each {|i| i.destroy}
      respond_to do |format|
        if @request.destroy
          format.html { redirect_to admin_expense_report_requests_path(), notice: "Rendición eliminada con éxito." }
          format.json { render :index, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_requests_path(), notice: "Ocurrió un error" }
          format.json { render :index, status: :ok, location: @request }
        end
      end
    end

    def take_request
      params[:take_request] == 'true' ? state = 'attended' : state = 'approved'
      params[:take_request] == 'true' ? assistant = current_user.id :  assistant = nil
      respond_to do |format|
        if @request.update(assistant_id: assistant, request_state_id: ExpenseReport::RequestState.find_by(name: state).id)
          UserNotifierMailer.notification_request_attended(@request).deliver if state == 'attended'
          ExpenseReport::RequestHistory.create(user_id: current_user, request_id: @request.id, request_state_id: ExpenseReport::RequestState.find_by(name: state).id)
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Rendición actualizada con éxito." }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @request }
        end
      end
    end

    def close
      respond_to do |format|
        if @request.update(closed_at: DateTime.now, request_state: ExpenseReport::RequestState.find_by(name: "closed"))
          ExpenseReport::RequestHistory.create(user_id: current_user.id, request_id: @request.id, request_state_id: ExpenseReport::RequestState.find_by(name: "closed").id)
          UserNotifierMailer.notification_request_close(@request).deliver
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Request fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_requests_path(@request), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @request }
        end
      end
    end

    def inbox
      @status = params[:status]
      @all_status= ExpenseReport::RequestState.where.not(name: ['draft', 'envoy', 'open']).map {|status| [status.code, status.id]}

      respond_to do |format|
        format.html
        format.json { render json: InboxDatatable.new(view_context) }
      end
    end
    
    def requests_list
      @requests = ExpenseReport::Request.includes(:request_state).where.not(expense_report_request_states: { name: 'draft' })
      render xlsx: 'requests_list.xlsx.axlsx', filename: "listada de rendiciones #{Date.today}.xlsx"
    end

    private

    def user_not_authorized
      redirect_to(admin_expense_report_request_path)
    end

    def set_request
      @request = ExpenseReport::Request.find(params[:id])
    end

    def request_params
      params.require(:requet).permit(:name, :description, :subcategory_id, :category, :user_id, :take_ticket, :payment_date, :destination_country_id, files: [], invoices_attributes: [:id, :category_id])
    end
  end
end