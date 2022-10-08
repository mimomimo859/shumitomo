class Thema < ApplicationRecord
  has_many :end_user_themas
  has_many :end_users, through: :end_user_themas
  has_many :participants
  has_many :end_users, through: :participants

  
end
