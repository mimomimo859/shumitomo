class ApplicationController < ActionController::Base
  #deviseにまつわる画面に行った時、全てのコントローラーが実行される前にconfigure_permitted_parametersが起動する。
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  #このコントローラーに記述してあるアクションは、adminだけが使用できる
  #admin_urlメソッドを参照する
  before_action :authenticate_admin!, if: :admin_url

  def admin_url
    #request.fullpathで、飛んだ先のpathを全て取得する
    #include?(val)で、valと同じ要素が含まれていれば、trueを返す
    #つまり、パスに「/admin」が含まれているかどうかを確認する
    request.fullpath.include?("/admin")
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :customer
        root_path
    elsif resource_or_scope == :admin
        new_admin_session_path
    else
        root_path
    end
  end

  #protectedは呼び出された他のコントローラからも参照できる
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
