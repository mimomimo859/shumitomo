class Public::RoomsController < ApplicationController
before_action :prevent_url, except: [:create]

  def create
    #「current_end_user_room_id」に０を代入
    current_end_user_room_id = 0
    #「current_end_user_rooms」にRoom中間テーブル内のcurrent_end_user.idを持ったデータを代入
    current_end_user_rooms = EndUserRoom.where(end_user_id: current_end_user.id)
    current_end_user_rooms.each do |current_end_user_room|
      current_end_user_room_id = current_end_user_room.room_id
    end
    #「partner_end_user_room_id」に１を代入
    partner_end_user_room_id = 1
    #「partner_end_user_rooms」にRoom中間テーブル内のpartner_idを持ったデータを代入
    partner_end_user_rooms = EndUserRoom.where(end_user_id: params[:partner_id])
    partner_end_user_rooms.each do |partner_end_user_room|
      partner_end_user_room_id = partner_end_user_room.room_id
    end

    unless current_end_user_room_id == partner_end_user_room_id
     EndUserRoom.transaction do
      # テーブルへのアクセス処理
      room = Room.create!
      EndUserRoom.create!(end_user_id: current_end_user.id, room_id: room.id)
      EndUserRoom.create!(end_user_id: params[:partner_id], room_id: room.id)
     end
     # トランザクション処理が成功した場合の処理
     # rooms/show.html.erbへ遷移
      redirect_to room_path(room)
    else
     # トランザクション処理が失敗した場合の処理
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

  def prevent_url
   @room = Room.find(params[:id])
   @end_user_rooms = EndUserRoom.where(room_id: @room.id)
    # ログインユーザーとルームに参加しているユーザーが同じじゃない時
    unless @end_user_rooms.first.end_user_id == current_end_user.id
      redirect_to root_path and return
    else @end_user_rooms.last.end_user_id != current_end_user.id
      @end_user_rooms.last.end_user_id != current_end_user.id
    end
  end

end
