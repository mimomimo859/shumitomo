class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum sex: { man: 0, female: 1, non_binary: 2 }

  has_one_attached :profile_image, dependent: :destroy

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [100, 100]).processed
  end

  def self.guest_sign_in
    # EndUserの中から(name: "guest", email: 'guest@example.com', sex: "non_binary")に当てはまるアカウントがあればそれを取り出す
    # もし、当てはまることがなければ新規にアカウントを作成してend_userに代入する
    EndUser.find_or_create_by!(name: "guest", email: 'guest@example.com', sex: "non_binary") do |end_user|
      # end_userのpasswordにランダムで作成したパスワードを設定する
      end_user.password = SecureRandom.urlsafe_base64
    end
  end

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  #ユーザーが投稿に対して既にいいねしているか判定する
  def already_liked?(post)
    likes.exists?(post_id: post.id)
  end
  
  # タグとユーザーと投稿記事をまとめて曖昧検索する
  def self.search(search)
    if search != nil
      EndUser.where('name LIKE(?)', "%#{search}%")
    else
      EndUser.all
    end
  end
  
end
