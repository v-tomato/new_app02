class User < ApplicationRecord
  has_many :meetings, dependent: :destroy
  
  before_save :downcase_email
  # create_activation_digestというメソッドを探し、ユーザーを作成する前に実行するようになる
  before_create :remember_token, :activation_token
  
  before_create :create_activation_digest
  
  # 仮属性なのでattr_accessorに追加
  attr_accessor :remember_token, :activation_token, :reset_token
  
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
  
  
  # クラスオブジェクト/トークン生成用メソッド
  class << self
  
    # 暗号化したトークンを作る
    def digest(string)
      # 複数のブラウザを同時に立ち上げた時のエラーを回避
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
     # トークンを作る
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # 記憶トークンをユーザーと関連付け、トークンに対応する記憶ダイジェストをDBに保存
  def remember
    # ランダムな文字列の入った、remember_token属性が設定
    self.remember_token = User.new_token
    # 記憶ダイジェストを更新する
    # ランダムな文字列が入ったremember_tokenを、暗号化メソッドのUser.digestに渡して、
    # 暗号化された、ランダムな文字列によって、remember_digestを更新
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # # 渡されたトークンがダイジェストと一致したらtrueを返す・トークンを照合
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #   # BCrypt::Password.new(remember_digest) == remember_token
  # end
  
  # アカウント有効化のダイジェスト("#{attribute}_digest")と、
  # 渡されたトークン(token)が一致するかどうかをチェック
  # (11.3.1)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する・永続化を破棄
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # activatedをtrueに
  def activate
    update_attribute(:activated, true)
  end

  # パスワード再設定の為のトークンとダイジェストをまとめて生成
  def create_reset_digest
    self.reset_token = User.new_token
    # update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # パスワード再設定の為のメール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  
  
    private
    
    # アドレスを全て小文字にするメソッド
    def downcase_email
      email.downcase!
    end
    
    # アクティベーション用 Userクラス内のみで使用
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
