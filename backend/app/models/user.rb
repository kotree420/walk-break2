class User < ApplicationRecord
  has_many :bookmarks, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :walking_routes, dependent: :destroy
  has_many :bookmarked_walking_routes, through: :bookmarks, source: :walking_route

  default_scope { where(is_deleted: false) }

  scope :latest, -> { order(created_at: :desc) }
  # ユーザー管理機能で全てのユーザーを取得する場合は以下のunscopeを使う
  scope :with_deleted, -> { unscope(where: :is_deleted) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && (is_deleted == false)
  end

  mount_uploader :profile_image, AvatarUploader

  with_options presence: true do
    with_options uniqueness: true do
      validates :name, length: { maximum: 20 }
    end
  end
  validates :comment, with_line_break: { maximum: 140 }, allow_blank: true
  validates :email, check_guest_regex: true
  validates :body_weight, numericality: { greater_than: 0 }, if: :body_weight

  def self.guest
    # @example.comのドメインに対するバリデーションをスキップするためsaveを使用
    name = SecureRandom.alphanumeric(10)
    email = "#{name}@example.com"
    comment = "こちらに自己紹介を記載できます。ゲストログイン中のため、ログアウト後は情報が削除されます。"
    password = SecureRandom.urlsafe_base64
    guest_user = User.new(name: name, email: email, comment: comment, password: password)
    guest_user.save(validate: false)
    guest_user
  end

  def bookmarked?(bookmarks, current_user_id)
    bookmarks.pluck(:user_id).include?(current_user_id)
  end

  def self.search(keyword)
    if keyword.present?
      where('name LIKE ?', "%#{keyword}%")
    else
      all
    end
  end
end
