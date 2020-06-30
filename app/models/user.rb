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
  
    private
    # アドレスを全て小文字にするメソッド
    def downcase_email
      email.downcase!
    end
    
end
