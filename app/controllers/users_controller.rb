class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all.page(params[:page])
  end 
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page])
  end
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  #update前の準備
  def edit
    @user = User.find(params[:id])
  end 
  
  #変更した情報を更新
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end 
  end 
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
  end

  private
    #ここからプライベート
    
    def user_params
       params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #権利権限があるかどうかの確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
      # メールアドレスを全て小文字にする

    def downcase_email
      self.email = email.downcase                                                 # emailを小文字化してUserオブジェクトのemail属性に代入
    end

    # 有効化トークンとダイジェストを作成および代入する

    def create_activation_digest
      self.activation_token   =   User.new_token                                  # ハッシュ化した記憶トークンを有効化トークン属性に代入
      self.activation_digest  =   User.digest(activation_token)                   # 有効化トークンをBcryptで暗号化し、有効化ダイジェスト属性に代入
    end
end
