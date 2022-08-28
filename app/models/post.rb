class Post < ApplicationRecord

  belongs_to :end_user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy

  attachment :picture

  def liked?(current_end_user)
   likes.where(end_user_id: current_end_user.id).exists?
  end

end
