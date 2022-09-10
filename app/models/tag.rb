class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # タグとユーザーと投稿記事をまとめて曖昧検索する
  def self.search(search)
    if search != nil
      Tag.where('tag_name LIKE(?)', "%#{search}%")
    else
      Tag.all
    end
  end

end
