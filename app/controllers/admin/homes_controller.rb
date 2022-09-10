class Admin::HomesController < ApplicationController

  def top
   # 投稿内容全てを作成日時の降順に並び替えて表示する（新着順）
   @posts = Post.published.order("created_at DESC").page(params[:page]).per(10)
  end

end
