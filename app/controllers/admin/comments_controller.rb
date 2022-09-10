class Admin::CommentsController < ApplicationController

  def destroy
   @comment = Comment.find(params[:id])
   @post = @comment.post
   @comment.destroy!
   flash.now[:alert] = '投稿を削除しました'
   #renderしたときに@postのデータがないので@postを定義
  end

end
