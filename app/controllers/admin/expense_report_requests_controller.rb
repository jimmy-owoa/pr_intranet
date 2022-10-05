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
      @users = General::User.all.map { |u| [u.full_name, u.id] }
    end

    def show
      #authorize @request, :show?
      @supervisor = @request.user.get_name_supervisor
    end

    def update
      # authorize @request, :show?
      respond_to do |format|
        if @request.update(request_params)
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "request fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @request }
        end
      end
    end
    
    def destroy
    end

    def take_request
      params[:take_request] == 'true' ? state = 'attended' : state = 'approved'
      params[:take_request] == 'true' ? assistant = current_user.id :  assistant = nil
      respond_to do |format|
        if @request.update(assistant_id: assistant, request_state_id: ExpenseReport::RequestState.find_by(name: state).id)
          ExpenseReport::RequestHistory.create(user_id: current_user, request_id: @request.id, request_state_id: ExpenseReport::RequestState.find_by(name: state).id)
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Rendición actualizada con éxito." }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_request_path(@ticket), notice: "Ocurrió un error" }
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

    private

    def user_not_authorized
      redirect_to(admin_expense_report_request_path)
    end

    def set_request
      @request = ExpenseReport::Request.find(params[:id])
    end

    def request_params
      params.require(:requet).permit(:name, :description, :subcategory_id, :category, :user_id, :take_ticket, files: [])
    end
  end
end