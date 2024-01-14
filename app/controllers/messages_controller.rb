class MessagesController < ApplicationController
  # before_action :set_message, only: %i[ show edit update destroy ]
  before_action :set_room, only: %i[ create ]


  def create
    @message = current_user.text_messages.build(message_params)
    if @message.save
      render turbo_stream: turbo_stream.update(
        "message_form_#{@room.id}",
        partial: 'form',
        locals: {room: @room, message: Message.new}
      )
    else
      @messages = @room.messages
      render 'rooms/show', status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end
end
