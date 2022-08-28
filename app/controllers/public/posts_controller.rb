class Public::PostsController < ApplicationController

  def new
   #空のitem_paramsを@itemに代入する
   @post = Post.new
  end

  def create
   #newアクションで入力されたデータを@postに代入する
   @post = Post.new(post_params)
   #newアクションで入力されたデータを保存する
   if @post.save!
    #indexアクションを通って「@post = Post.page(params[:page])」を受け取ってから「posts_path」へ移動する
    redirect_to posts_path
   else
    #indexアクションを通らずに直接「posts_path」へ移動するため「@post = Post.all」を記載する
    @post = Post.all
    render :index
   end
  end

  def index
   @posts = Post.page(params[:page])
  end

  def edit
   #URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
  end

  def update
   #URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
   if @post.update(post_params)
    #indexアクションを通って「@post = Post.page(params[:page]」を受け取ってから「posts_path」へ移動する
    redirect_to posts_path
   else
    #indexアクションを通らずに直接「posts_path」へ移動するため「@post = Post.page(params[:page])」を記載する
    @post = Post.page(params[:page])
    render :index
   end
  end

  def destroy
   #URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
    if @post.destroy!
    redirect_to '/posts'
    else
    render :index
    end
  end

  def show
   #URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @post = Post.find(params[:id])
   #特定の投稿に紐付いたコメントを全て取り出して@commentsに代入する
   @comments = @post.comments
   @comment = Comment.new
  end

  #private以下の内容はは、postのコントローラ内でしか参照できない
  private
  #private以下はストロングパラメーターを記載する
  #ストロングパラメーターとは、指定したキーを持つパラメーターのみを受け取るように制限するもの

  def post_params
   #require(:モデル名)の意味は、「登録するのはどのテーブルなのか？」ということ
   #permitで保存するカラム名を選択する
   params.require(:post).permit(:end_user_id, :content, :picture)
  end

end
