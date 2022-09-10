class Admin::EndUsersController < ApplicationController

  def index
   @end_users = EndUser.all
  end

  def show
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @end_user = EndUser.find(params[:id])
  end

  def edit
   # URLの末尾に記載されたidを取得して、そのidに該当するPostモデルのデータを取得する
   @end_user = EndUser.find(params[:id])
  end

  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(current_end_user_params)
       redirect_to admin_end_user_path(@end_user.id)
    else
       render :update
    end
  end

  private

  def current_end_user_params
      params.require(:end_user).permit(:name, :sex, :self_introduction, :email, :profile_image, :is_deleted)
  end

end
