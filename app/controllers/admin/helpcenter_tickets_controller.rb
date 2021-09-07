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
    end

    def edit
      authorize @ticket, :show?
      @users = General::User.all.map { |u| [u.full_name, u.id] }
    end

    def create
      @users = General::User.all.map { |u| [u.full_name, u.id] }
      @ticket = Helpcenter::Ticket.new(ticket_params)
      @ticket.created_by_admin = true

      respond_to do |format|
        if @ticket.save
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ticket fue creado con éxito.' }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      authorize @ticket, :show?
      @message = Helpcenter::Message.new
      @messages = @ticket.chat_messages
    end

    def take_ticket
      assistant = params[:take_ticket] == 'true' ? current_user.id : nil
      
      respond_to do |format|
        if @ticket.update(assistant_id: assistant, attended_at: DateTime.now, status: 'Atendido')
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ticket fue actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ocurrió un error' }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def close
      respond_to do |format|
        if @ticket.update(closed_at: DateTime.now, status: 'Cerrado')
          # UserNotifierMailer.notification_ticket_close(@ticket).deliver
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ticket fue actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ocurrió un error' }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def update
      authorize @ticket, :show?
      respond_to do |format|
        if @ticket.update(ticket_params)
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ticket fue actualizado con éxito.' }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ocurrió un error' }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    def destroy
      @ticket.destroy
      respond_to do |format|
        format.html { redirect_to admin_helpcenter_tickets_path, notice: 'Ticket fue eliminado con éxito.' }
        format.json { head :no_content }
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
      params.require(:ticket).permit(:name, :description, :category_id, :user_id, files: [])
    end
  end
end
