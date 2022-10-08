class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.integer :end_user_id, null: false
      t.integer :thema_id, null: false
      t.boolean :status, default: false, null: false
      t.timestamps
    end
  end
end
