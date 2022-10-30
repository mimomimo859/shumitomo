class Public::ThemasController < ApplicationController
before_action :prevent_url, only: [:edit, :update, :destroy]

  def new
    @thema = Thema.new
  end

  def destroy
    # URLの末尾に記載されたidを取得して、そのidに該当するThemaモデルのデータを取得する
    @thema = Thema.find(params[:id])
    if @thema.destroy!
    redirect_to '/themas'
    else
    flash[:notice] = '削除できませんでした'
    render :index
    end
  end

  def create
    @thema = Thema.new(thema_params)
    @thema.save
    redirect_to themas_path
  end

  def index
    @themas = Thema.page(params[:page])
  end

  def update
    # URLの末尾に記載されたidを取得して、そのidに該当するThemaモデルのデータを取得する
    @thema = Thema.find(params[:id])
    if @thema.update(thema_params)
    # indexアクションを通って「@thema = Thema.page(params[:page]」を受け取ってから「themas_path」へ移動する
    redirect_to themas_path
    else
    # indexアクションを通らずに直接「themas_path」へ移動するため「@thema = Thema.page(params[:page]」を記載する
    @thema = Thema.page(params[:page])
    flash[:notice] = '更新できませんでした'
    render :index
    end
  end

  def edit
    @thema = Thema.find(params[:id])
  end

  def show
    @thema = Thema.find(params[:id])
  end

  private

  def thema_params
    params.require(:thema).permit(:explanation, :limit, :thema, :end_user_id)
  end

  def prevent_url
   @thema = Thema.find(params[:id])
    if @thema.end_user_id != current_end_user.id
      redirect_to root_path
    end
  end

end
