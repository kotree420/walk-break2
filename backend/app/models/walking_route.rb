class WalkingRoute < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  belongs_to :user
  has_many :bookmarked_users, through: :bookmarks, source: :user

  with_options presence: true do
    validates :name, length: { maximum: 20 }
    validates :comment, with_line_break: { maximum: 140 }
    validates :distance, numericality: true
    validates :duration, numericality: true
    validates :start_address
    validates :end_address
    validates :encorded_path
  end

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(:created_at) }
  scope :distance_longest, -> { order(distance: :desc) }
  scope :distance_shortest, -> { order(:distance) }
  scope :duration_longest, -> { order(duration: :desc) }
  scope :duration_shortest, -> { order(:duration) }

  def bookmarks_count(bookmarks)
    count = []
    bookmarks.each do |bookmark|
      if bookmark.user
        count << bookmark.user
      end
    end
    count = count.length
  end

  def self.search(keyword)
    if keyword.present?
      where('start_address LIKE ?', "%#{keyword}%").or(where('end_address LIKE ?', "%#{keyword}%"))
    else
      all
    end
  end
end
