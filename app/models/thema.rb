class Thema < ApplicationRecord
  has_one :end_user
  has_many :participants
  has_many :end_users, through: :participants
end
