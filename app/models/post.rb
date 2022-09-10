class Post < ApplicationRecord

  belongs_to :end_user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :liked_end_users, through: :likes, source: :end_user

  enum status: { published: 0, draft: 1 }
  
  attachment :picture

  # ログインユーザーが既にいいねしているかどうか判定する
  def liked?(current_end_user)
   likes.exists?(end_user_id: current_end_user.id)
  end

  # 新しいタグを作成する
  def save_posts(tags)
   # タグが存在していれば、タグの名前を配列として全て取得
   current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
   # 現在取得したタグから送られてきたタグを除いてoldtagとする
   old_tags = current_tags - tags
   # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
   new_tags = tags - current_tags

   # 古いタグを消す
   old_tags.each do |old_name|
     self.tags.delete Tag.find_by(tag_name:old_name)
   end

   # 新しいタグを保存
   new_tags.each do |new_name|
    format_new_name = new_name
    # 全角の＃を半角の#に置き換える
    # new_nameの中に全角の＃が無いか判定する
    if new_name.include?("＃")
     # 全角の＃が含まれていた場合、半角の#に変換してformat_new_nameに代入する
     format_new_name = new_name.gsub!("＃","#")
    end
     post_tag = Tag.find_or_create_by(tag_name:format_new_name)
     self.tags << post_tag
   end
  end

  # タグとユーザーと投稿記事をまとめて曖昧検索する
  def self.search(search)
    if search != nil
      Post.where('content LIKE(?)' , "%#{search}%")
    else
      Post.all
    end
  end

end
