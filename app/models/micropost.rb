class Micropost < ActiveRecord::Base
  # self.per_page = 30

  belongs_to :user

  default_scope -> { order('created_at DESC') }

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end
