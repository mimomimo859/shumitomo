class Public::LikesController < ApplicationController

  before_action :set_post, only: [:create, :destroy]

  def create
   @post = Post.find(params[:post_id])
   #end_user_idには、ログイン中のユーザーidを指定する
   #post_idには、ルーティングに含まれている「:post_id」を指定する
   if @post.end_user != current_end_user
      @post_like = Like.new(end_user_id: current_end_user.id, post_id: params[:post_id])
      @post_like.save!
   end
  end

  def destroy
   @post = Post.find(params[:post_id])
   #end_user_idがログイン中のユーザーidで、かつpost_idがURLに含まれているidと一致するデータをLikeテーブルから見つけ出す
   if @post.end_user != current_end_user
      @post_like = Like.find_by(end_user_id: current_end_user.id, post_id: params[:post_id])
      @post_like.destroy!
   end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

end
