class Public::RelationshipsController < ApplicationController
 # followメソッドとunfollowメソッドはモデルで定義したものを使用している。
 def create
  current_end_user.follow(params[:end_user_id])
  redirect_to request.referer
 end

 def destroy
  current_end_user.unfollow(params[:end_user_id])
  redirect_to request.referer
 end

 def index
  @end_users = current_end_user.matching
 end

end
