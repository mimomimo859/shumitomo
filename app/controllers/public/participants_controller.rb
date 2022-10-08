class Public::ParticipantsController < ApplicationController

 def participant
   @participant = current_end_user.participants.find_or_create_by(thema_id: params[:id])
   # participantカラムをtrueに変更する
   @participant.update(status: true)
   redirect_to themas_path
 end

 def rejoin
   @participant = current_end_user.participants.find_or_create_by(thema_id: params[:id])
   # participantカラムをtrueに変更する
   @participant.update(status: true)
   redirect_to themas_path
 end

 def unparticipant
   @participant = current_end_user.participants.find_or_create_by(thema_id: params[:id])
   # participantカラムをfalseに変更する
   @participant.update(status: false)
   redirect_to themas_path
 end

private

  def participant_params
    params.require(:participant).permit(:end_user_id, :thema_id, :participant)
  end

end
