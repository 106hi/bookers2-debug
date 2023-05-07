class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    current_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
    another_entry = Entry.create((entry_params).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @my_user_id = current_user.id
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :room_id)
  end
end
