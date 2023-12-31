class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.micropost.image.resize
  end

  scope :recent_posts, ->{order(created_at: :desc)}
  scope :relate_posts, ->(user_ids){where user_id: user_ids}

  validates :content, presence: true,
            length: {maximum: Settings.micropost.content.length.max}

  validates :image, content_type: {in: Settings.micropost.image.content_type},
            size: {less_than: Settings.micropost.image.size.max.megabytes}
end
