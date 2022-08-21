class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :end_user_id, null: false
      t.integer :post_id, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
