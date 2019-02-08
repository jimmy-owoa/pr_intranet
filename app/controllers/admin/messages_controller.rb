module Admin
  class MessagesController < ApplicationController
    layout 'admin'
    before_action :set_message, only: [:show, :edit, :update, :destroy]

    def index
      @messages = General::Message.all
    end

    def show
      add_breadcrumb "Messages", :admin_messages_path
    end
    
    def new
      add_breadcrumb "Messages", :admin_messages_path
      @message = General::Message.new
      @message_types = General::Message::MESSAGE_TYPES
    end

    def edit
      add_breadcrumb "Messages", :admin_messages_path
    end

    def create
      @message = General::Message.new(message_params)
      respond_to do |format|
        if @message.save
          format.html { redirect_to admin_message_path(@message), notice: 'Message was successfully created.'}
          format.json { render :show, status: :created, location: @message}
          format.js
        else
          format.html {render :new}
          format.json {render json: @message.errors, status: :unprocessable_entity}
          format.js
        end
      end
    end

    def update
      respond_to do |format|
        if @message.update(message_params)
          format.html { redirect_to admin_message_path(@message), notice: 'Message was successfully updated.'}
          format.json { render :show, status: :ok, location: @message }
        else
          format.html { render :edit}
          format.json { render json: @message.errors, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @message.destroy
      respond_to do |format|
        format.html { redirect_to admin_messages_path, notice: 'Message was successfully destroyed.'}
        format.json { head :no_content }
      end
    end

    private

    def set_message
      @message = General::Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:title, :content, :message_type, :is_const, :image)
    end
  end
end