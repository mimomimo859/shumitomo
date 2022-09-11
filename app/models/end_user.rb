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

  # following_end_user:中間テーブルを通してfollowedモデルのフォローされる側を取得すること
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # follower_end_user:中間テーブルを通してfollowerモデルのフォローする側を取得すること
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_end_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_end_user, through: :followed, source: :follower # 自分をフォローしている人


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

  # ユーザーをフォローする
  def follow(end_user_id)
    follower.create(followed_id: end_user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(end_user_id)
    follower.find_by(followed_id: end_user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(end_user)
    following_end_user.include?(end_user)
  end

  # お互いにフォローしている
  def matching(end_user)
   following & followers
  end

end
