class Public::CommentsController < ApplicationController

  def create
   @post = Post.find(params[:post_id])
   @comment = Comment.new(comment_params)
   @comment.end_user_id = current_end_user.id
    if @comment.save
      # renderは指定したviewsを呼び出すだけでアクションを通過しない
      # よってFlash Messageが表示されたままになるのを防ぐため「flash」に「.now」をつける
      flash.now[:notice] = 'コメントを投稿しました'
      render :post_comments  #render先にjsファイルを指定
    else
      render :error  #render先にjsファイルを指定
      #flash.now[:alert] = "コメントを入力してください"
    end
  end

  def destroy
   Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
   flash.now[:alert] = '投稿を削除しました'
   #renderしたときに@postのデータがないので@postを定義
   @post = Post.find(params[:post_id])
   render :post_comments  #render先にjsファイルを指定
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :end_user_id, :post_id)
  end

end
