class Thema < ApplicationRecord
  has_one :end_user
  has_many :participants
  has_many :end_users, through: :participants
  validates :end_user_id, presence: true
  validates :thema, presence: true
  validates :explanation, presence: true
  validates :limit, presence: true
end
