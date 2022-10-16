# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #end_user_stateメソッドをログイン前に実行する
  #ただし、createアクションは除く
  before_action :end_user_state, only: [:create]

  def guest_sign_in
    end_user = EndUser.guest_sign_in
    sign_in end_user
    redirect_to my_profile_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def end_user_state
   #【処理内容１】
   #入力されたemailからアカウントを1件取得する
   @end_user = EndUser.find_by(email: params[:end_user][:email])
   #アカウントを取得できなかった場合、このメソッドを終了する
   return if !@end_user
   #【処理内容２】
   #取得したアカウントのパスワードと入力されたパスワードが一致している（処理結果ture）
   #かつ取得したアカウントのis_deletedカラムの中身がtureだった時【処理内容３】を実行する
    if @end_user.valid_password?(params[:end_user][:password]) && @end_user.is_deleted
   #【処理内容３】
   #【処理内容２】の結果がfalseだった場合は、新規登録画面に遷移する
     redirect_to new_end_user_registration_path
    end
  end

end
