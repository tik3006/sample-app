class SessionsController < ApplicationController
  def new
  end
  
def create
    @user = User.find_by(email: params[:session][:email].downcase)              # paramsハッシュで受け取ったemail値を小文字化し、email属性に渡してUserモデルから同じemailの値のUserを探して、user変数に代入
    if @user && @user.authenticate(params[:session][:password])                 # user変数がデータベースに存在し、なおかつparamsハッシュで受け取ったpassword値と、userのemail値が同じ(パスワードとメールアドレスが同じ値であれば)true
      if @user.activated?                                                       # userが有効の処理
        log_in @user                                                            # sessions_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時cookiesとして保存）にidを送る
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) # ログイン時、sessionのremember_me属性が1(チェックボックスがオン)ならセッションを永続的に、それ以外なら永続的セッションを破棄する
        redirect_back_or @user                                                  # userの前のページもしくはdefaultにリダイレクト
      else                                                                
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
  
   # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:fowarding_url]  || default)
    session.delete(:fowarding_url)
  end 
  
  #アクセスしようとしたURｌを記憶する
  def store_location
    session[:foward_url] = request.original_url if request.get?
  end 
end
