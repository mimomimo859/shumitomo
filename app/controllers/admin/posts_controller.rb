class Admin::PostsController < ApplicationController

  def show
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
   # 特定の投稿に紐付いたコメントを全て取り出して@commentsに代入する
   @comments = @post.comments
   @comment = Comment.new
   @like = Like.new
   @tags = @post.tags
  end

end
