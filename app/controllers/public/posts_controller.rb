class Public::PostsController < ApplicationController

  def new
   # 空のitem_paramsを@itemに代入する
   @post = Post.new
  end

  def create
   # newアクションで入力されたデータを@postに代入する
   @post = Post.new(post_params)
   # 送られてきた複数のtag_nameを','を目印に分割して配列として受け取る
   tag_list = params[:post][:tag_name].split(',')
   # newアクションで入力されたデータを保存する
   if @post.save!
      @post.save_posts(tag_list)
    # indexアクションを通って「@post = Post.page(params[:page])」を受け取ってから「posts_path」へ移動する
    redirect_to posts_path
   else
    # indexアクションを通らずに直接「posts_path」へ移動するため「@post = Post.all」を記載する
    @post = Post.all
    flash.now[:alert] = '投稿に失敗しました'
    render :new
   end
  end

  def index
   @posts_published = Post.published.page(params[:page]).per(10).order("created_at DESC")
   # 検索フォームに入力があった場合
   if params[:search].present?
   # 投稿ステータスがpublishedの投稿データを検索ファームから送られてきた文字列で検索して@postsに代入
      @posts = @posts_published.posts_serach(params[:search])
   # paramsで:tag_idを受け取ってタグで絞込む場合（検索ボタンをクリックしてパラメータでtag_idを受け取ったときに発動する）
   elsif params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.order(created_at: :desc)
   # 普通にページを表示させた場合
   else
    # 作成された日時を降順に並び替えて表示する（新着順）
      @posts = @posts_published.all.order(created_at: :desc)
   end
   @tag_lists = Tag.all
  end

  def edit
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
  end

  def update
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
   if @post.update(post_params)
    # indexアクションを通って「@post = Post.page(params[:page]」を受け取ってから「posts_path」へ移動する
    redirect_to posts_path
   else
    # indexアクションを通らずに直接「posts_path」へ移動するため「@post = Post.page(params[:page])」を記載する
    @post = Post.page(params[:page])
    flash[:notice] = '更新できませんでした'
    render :index
   end
  end

  def destroy
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
    if @post.destroy!
    redirect_to '/posts'
    else
    flash[:notice] = '削除できませんでした'
    render :index
    end
  end

  def show
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
   # 特定の投稿に紐付いたコメントを全て取り出して@commentsに代入する
   @comments = @post.comments
   @comment = Comment.new
   @like = Like.new
   @tags = @post.tags
  end

  def confirm
  @posts = current_end_user.posts.draft.page(params[:page]).reverse_order
   # 検索フォームに入力があった場合
   if params[:search].present?
      posts = Post.posts_serach_confirm(params[:search])
   # 普通にページを表示させた場合
   else
    # 作成された日時を降順に並び替えて表示する（新着順）
      posts = Post.published.order(created_at: :desc)
   end
  end

  # private以下の内容はは、postのコントローラ内でしか参照できない
  private
  # private以下はストロングパラメーターを記載する
  # ストロングパラメーターとは、指定したキーを持つパラメーターのみを受け取るように制限するもの

  def post_params
   # require(:モデル名)の意味は、「登録するのはどのテーブルなのか？」ということ
   # permitで保存するカラム名を選択する
   params.require(:post).permit(:end_user_id, :content, :picture, :status)
  end

end
