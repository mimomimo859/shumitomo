class Participant < ApplicationRecord
  belongs_to :end_user
  belongs_to :thema

    # テーマに参加する
  def participant(end_user_id)
    participant.create(participant_id: end_user_id)
  end

end
