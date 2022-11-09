module Admin
  class ChatMessagesController < AdminController
    def create
      @request = ExpenseReport::Request.find(params[:request_id].to_i)
      chat = Chat::Room.where(resource_id: params[:request_id].to_i, resource_type: params[:resource_type]).first_or_create
      respond_to do |format|
        if chat.messages.create(message: params[:message], user_id: current_user.id, files: params[:files] || [])
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "Mensaje Guardado" }
          format.json { render :show, status: :ok, location: @request }
        else
          format.html { redirect_to admin_expense_report_request_path(@request), notice: "No se pudo guardar el mensaje" }
          format.json { render :show, status: :ok, location: @request }
        end
      end
    end
  end
end