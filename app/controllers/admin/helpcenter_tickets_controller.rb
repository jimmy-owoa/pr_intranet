module Admin
  class HelpcenterTicketsController < AdminController
    before_action :set_ticket, only: [:edit, :show, :destroy, :update, :take_ticket, :close]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def index
      @status = params[:status]

      respond_to do |format|
        format.html
        format.json { render json: TicketsDatatable.new(view_context) }
      end
    end

    def new
      @ticket = Helpcenter::Ticket.new
      @users = General::User.all.map { |u| [u.full_name, u.id] }
      @subcategories = []
    end

    def tickets_list
      @tickets = Helpcenter::Ticket.all
      render xlsx: 'tickets_list.xlsx.axlsx', filename: "listada de tickets #{Date.today}.xlsx"
    end

    def edit
      authorize @ticket, :show?
      @users = General::User.all.map { |u| [u.full_name, u.id] }
      @subcategories = Helpcenter::Subcategory.where(category: @ticket.subcategory.category)
    end

    def create
      @users = General::User.all.map { |u| [u.full_name, u.id] }
      @ticket = Helpcenter::Ticket.new(ticket_params)
      @ticket.created_by_admin = true

      respond_to do |format|
        if @ticket.save
          Helpcenter::TicketHistory.create(user_id: current_user.id, ticket_id: @ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: "open").id)
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ticket fue creado con éxito." }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      authorize @ticket, :show?
      @user = General::User.with_deleted.find(@ticket.user_id)
      @message = Helpcenter::Message.new
      @messages = @ticket.chat_messages
      @supervisor = General::User.where(id_exa: @user.id_exa_boss).last.try(:full_name)
    end

    def take_ticket
      result = Helpcenter::Ticket.take_ticket(params[:take_ticket], @ticket, current_user)
      @ticket = result[:ticket]
      respond_to do |format|
        if result[:success] == true
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ticket fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def close
      respond_to do |format|
        if @ticket.update(closed_at: DateTime.now, status: Helpcenter::TicketState.find_by(status: "closed").status)
          Helpcenter::TicketHistory.create(user_id: current_user.id, ticket_id: @ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: "closed").id)
          UserNotifierMailer.notification_ticket_close(@ticket).deliver
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ticket fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def update
      authorize @ticket, :show?
      respond_to do |format|
        if @ticket.update(ticket_params)
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ticket fue actualizado con éxito." }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: "Ocurrió un error" }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def destroy
      Helpcenter::TicketHistory.create(user_id: current_user.id, ticket_id: @ticket.id, ticket_state_id: Helpcenter::TicketState.find_by(status: "deleted").status)
      @ticket.destroy
      respond_to do |format|
        format.html { redirect_to admin_helpcenter_tickets_path, notice: "Ticket fue eliminado con éxito." }
        format.json { head :no_content }
      end
    end

    def subcategories
      @subcategories = Helpcenter::Subcategory.where(category_id: params[:category_id])
      render :partial => "admin/helpcenter_tickets/subcategories", :object => @subcategories
    end

    def inbox
      @status = params[:status]

      respond_to do |format|
        format.html
        format.json { render json: InboxTicketsDatatable.new(view_context) }
      end
    end

    private

    def user_not_authorized
      redirect_to(admin_helpcenter_tickets_path)
    end

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:name, :description, :subcategory_id, :user_id, files: [])
    end
  end
end
