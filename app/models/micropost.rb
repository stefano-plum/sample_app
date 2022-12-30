class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500,500]
  end
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: {
    in: %w[image/jpeg image/gif image/png],
    message: "Must be a valid image format"
  }, size: {
    less_than: 5.megabytes,
    message: "Should be less than 5MB"
  }
  
  def like(user)
    likes.build(user_id: user.id)
    self.save
  end

  def unlike(user)
    like = likes.find_by(user_id: user.id)
    likes.delete(like)
    self.save
  end

  def liked?(user)
    !!like = likes.find_by(user_id: user.id) 
  end

end
