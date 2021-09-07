module Admin
  class HelpcenterMessagesController < AdminController
    before_action :set_ticket

    def create
      @message = @ticket.chat_messages.build(comment_params)
      @message.user = current_user

      respond_to do |format|
        if @message.save
          # UserNotifierMailer.notification_new_message_assistant(@ticket, @message.content).deliver
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Respondido con éxito.' }
          format.json { render :show, status: :ok, location: @ticket }
        else
          format.html { redirect_to admin_helpcenter_ticket_path(@ticket), notice: 'Ocurrió un error' }
          format.json { render :show, status: :ok, location: @ticket }
        end
      end
    end

    private

    def comment_params
      params.require(:helpcenter_message).permit(:content)
    end

    def set_ticket
      @ticket = Helpcenter::Ticket.find(params[:helpcenter_ticket_id])
    end
  end
end
