class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
   
# ユーザーネームを必須にする + 51文字以上の名前を無効にする
  validates :name, presence: true, length: { maximum: 50 } 
  
# 51文字以上の名前を無効にする + 256文字以上のアドレスを無効にする
  validates :email, presence: true, length: {maximum: 255}, 
                    # アドレスでない文字列を無効にする
                    format: { with: VALID_EMAIL_REGEX }, 
                    # 一意性のないアドレスを無効にする + 一意性のないアドレスの大文字小文字を区別しないようにする
                    uniqueness: { case_sensitive: false } 
  
  # パスワードの一意性 + 5文字以下を無効                  
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  
  attr_accessor :remember_token
  
  # クラスオブジェクト/トークン生成用メソッド
  class << self
     # トークンを作る
    def new_token
      SecureRandom.urlsafe_base64
    end
    
    # 暗号化したトークンを作る
    def digest(string)
      # 複数のブラウザを同時に立ち上げた時のエラーを回避
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
  
  # 記憶トークンをユーザーと関連付け、トークンに対応する記憶ダイジェストをDBに保存
  def remember
    self.remember_token = User.new_token
    # 記憶ダイジェストを更新する
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す・トークンを照合
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # BCrypt::Password.new(remember_digest) == remember_token
  end
  
  # ユーザーのログイン情報を破棄する・永続化を破棄
  def forget
    update_attribute(:remember_digest, nil)
  end
  
    private
    # アドレスを全て小文字にするメソッド
    def downcase_email
      email.downcase!
    end
    
end
