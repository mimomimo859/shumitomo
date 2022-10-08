class CreateEndUserThemas < ActiveRecord::Migration[6.1]
  def change
    create_table :end_user_themas do |t|
      t.integer :end_user_id, null: false
      t.integer :thema_id, null: false
      t.timestamps
    end
  end
end
