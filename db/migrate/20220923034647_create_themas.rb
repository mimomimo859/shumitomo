class CreateThemas < ActiveRecord::Migration[6.1]
  def change
    create_table :themas do |t|
      t.integer :end_user_id, null: false
      t.string :thema, null: false
      t.text :explanation, null: false
      t.datetime :limit, null: false
      t.timestamps
    end
  end
end
