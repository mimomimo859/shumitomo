class Like < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  #Likeテーブルの中でend_user_idに対するpost_idが重複していないこと
  validates_uniqueness_of :post_id, scope: :end_user_id
end
