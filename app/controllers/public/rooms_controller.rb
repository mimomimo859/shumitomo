class Public::RoomsController < ApplicationController

  def create
    current_end_user_room_id = 0
    current_end_user_rooms = EndUserRoom.where(end_user_id: current_end_user.id)
    current_end_user_rooms.each do |current_end_user_room|
      current_end_user_room_id = current_end_user_room.room_id
    end

    partner_end_user_room_id = 1
    partner_end_user_rooms = EndUserRoom.where(end_user_id: params[:partner_id])
    partner_end_user_rooms.each do |partner_end_user_room|
      partner_end_user_room_id = partner_end_user_room.room_id
    end

    unless current_end_user_room_id == partner_end_user_room_id
      room = Room.create
      EndUserRoom.create(end_user_id: current_end_user.id, room_id: room.id)
      EndUserRoom.create(end_user_id: params[:partner_id], room_id: room.id)
      # rooms/show.html.erbへ遷移
      redirect_to room_path(room)
    else
      redirect_to room_path(partner_end_user_room_id)
    end
  end

  def show
    @chat = Chat.new
    @room = Room.find(params[:id])
    @chat_message = Chat.where(room_id: @room.id)
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id, :end_user_id)
  end

end
