class Public::Posts::LikesController < ApplicationController

  def create
   #end_user_idには、ログイン中のユーザーidを指定する
   #post_idには、ルーティングに含まれている「:post_id」を指定する
   @post_like = Like.new(end_user_id: current_end_user.id, post_id: params[:post_id])
   @post_like.save!
   redirect_to post_path(params[:post_id])
  end

  def destroy
   #end_user_idがログイン中のユーザーidで、かつpost_idがURLに含まれているidと一致するデータをLikeテーブルから見つけ出す
   @post_like = Like.find_by(end_user_id: current_end_user.id, post_id: params[:post_id])
   @post_like.destroy!
   redirect_to post_path(params[:post_id])
  end


end
