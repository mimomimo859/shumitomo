class SearchesController < ApplicationController
  #before_action :authenticate_end_user!

  def search
   # 検索フォームから送られてきた内容をsearch_wordに代入する
    search_word = params[:search]
    # 全角の＃を半角の#に置き換える
    # 送られてきた params[:search]の中に全角の＃が無いか判定する
    if params[:search].include?("＃")
     # 全角の＃が含まれていた場合、半角の#に変換してsearch_wordに代入する
     search_word = params[:search].gsub!("＃","#")
    end
   # 検索フォームから送られてきた内容の先頭に「#」がついているか見極める
   unless search_word == '#'
    @end_users = EndUser.search(params[:search]).order('created_at DESC').page(params[:page])
    @posts_published = Post.published.page(params[:page]).per(10).order("created_at DESC")
    @posts = @posts_published.search(params[:search]).order('created_at DESC').page(params[:page])
   end
   # 「#」がついている=タグ検索
   @tags = Tag.search(params[:search]).order('created_at DESC').page(params[:page])
   render template: "public/posts/index"
  end

  def search_confirm
   @posts = Post.where(status: 'draft', end_user_id: current_end_user.id).where("content LIKE ?", "%#{params[:search_confirm]}%").order('created_at DESC').page(params[:page])
   render template: "public/posts/confirm"
  end

end
