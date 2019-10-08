class AccountActivationsController < ApplicationController
  
  def edit                                                                      #メール本文の認証リンクが押されたらこれが実行される
    user = User.find_by(email: params[:email])                                  #リンクのメールアドレスからid検索
    if user && !user.activated? && user.authenticated?(:activation, params[:id])#ユーザーが実在し、activateカラムがまだfalseで、activation_digestとメールのトークンが一致したら
      user.update_attribute(:activated,    true)                                #activateカラムをtrueにする
      user.update_attribute(:activated_at, Time.zone.now)                       #activated_atカラムに現時点の時間を入れる
      log_in user                                                               # session[:user_id]にユーザーidを入れ、ログイン
      flash[:success] = "Account activated!"                                    #成功フラッシュ
      redirect_to user                                                          #/users/idにリダイレクト
    else
      flash[:danger] = "Invalid activation link"                                #失敗フラッシュ
      redirect_to root_url                                                      #ルートページにリダイレクト 
    end
  end
end
