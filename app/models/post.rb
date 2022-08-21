class Post < ApplicationRecord
  belongs_to :end_user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  attachment :picture
end
