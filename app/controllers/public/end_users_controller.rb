class Public::EndUsersController < ApplicationController

  def update
   @end_user = EndUser.find(params[:id])
    if @end_user.update(current_end_user_params)
       redirect_to my_profile_path(current_end_user.id)
    else
       render :update
    end
  end

  def edit
   @end_user = EndUser.find(params[:id])
  end

  def show
   @end_user = EndUser.find(params[:id])
   @posts = Post.where(end_user_id: @end_user.id)
   @following_end_users = @end_user.following_end_user
   @follower_end_users = @end_user.follower_end_user
  end

  def my_profile
   @posts = Post.where(end_user_id: current_end_user.id)
  end

  def unsubscribe

  end

  def follows
   end_user = EndUser.find(params[:id])
   @end_users = end_user.following_end_user.page(params[:page]).per(3).reverse_order
  end

  def followers
   end_user = EndUser.find(params[:id])
   @end_users = end_user.follower_end_user.page(params[:page]).per(3).reverse_order
  end

  def withdraw
   @end_user = EndUser.find(current_end_user.id)
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
   @end_user.update(is_deleted: true)
   #セッション情報を全て削除します
   reset_session
   flash[:notice] = "退会処理を実行いたしました"
   #退会後は、トップ画面に遷移します
   redirect_to root_path
  end

  def likes
    # ログイン中のユーザーとユーザーidが等しい「いいねのレコード」を全て取得
    @end_user = EndUser.find(params[:id])
    # そして、そのいいねに紐づくpost_idも一緒に持ってくる
    likes = Like.where(end_user_id: @end_user.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  private

  def current_end_user_params
      params.require(:end_user).permit(:name, :sex, :self_introduction, :email, :profile_image)
  end

end
