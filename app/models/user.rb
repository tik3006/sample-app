class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  #メソッド参照
  before_create :create_activation_digest
  
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remenber_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remenber_digest, nil)
  end
  
  #アカウントを有効にする
  def active
  update_columns(activated: FILL_IN, activated_at: FILL_IN)
  end 
  
  #有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end 
  
# パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  FILL_IN, reset_sent_at: FILL_IN)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
   # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

   private

    # メールアドレスをすべて小文字にする
    def downcase_email
     email.downcase!
    end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    # ハッシュ化した記憶トークンを有効化トークン属性に代入
    self.activation_token = User.new_token
    # 有効化トークンをBcryptで暗号化し、有効化ダイジェスト属性に代入
    self.activation_digest = User.digest(activation_token)
  end
end