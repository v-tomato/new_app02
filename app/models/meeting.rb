class Meeting < ApplicationRecord
  belongs_to :user
  has_one_attached :picture

  validates :user_id, presence: true
  validates :title, presence: true
  validates :start_time, presence: true
  
  validate :validate_picture
  
  def resize_picture
    return self.picture.variant(resize: '100x100').processed
  end
  
  
  private
    # def only_user_id
    #   time.presence or memo.presence or picture.attached?
    # end

    def validate_picture
      if picture.attached?
        if !picture.content_type.in?(%('image/jpeg image/jpg image/png image/gif'))
          errors.add(:picture, 'はjpeg, jpg, png, gif以外の投稿ができません')
        elsif picture.blob.byte_size > 5.megabytes
          errors.add(:picture, "のサイズが5MBを超えています")
        end
      end
    end
  
end
