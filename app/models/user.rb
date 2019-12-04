class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :places, foreign_key: :mapmaster_id
  has_many :missions, foreign_key: :captaingreen_id

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  mount_uploader :avatar, AvatarUploader

  LEVELS = %w[rookie apprentice champion hero legend]

  validates :username, presence: true, uniqueness: true, allow_blank: false
  # validates :email, presence: true, format: { with: /\A.*@.*\..{2,3}\z/ }
  # validates :password, presence: true, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}\z/ }

  validates :first_name, presence: true, allow_blank: false
  validates :last_name, presence: true, allow_blank: false
  validates :city, presence: true
  validates :zip_code, presence: true, format: { with: /\A([0-9]{5})|(2[AB]\d{3})\z/ }
  validates :country, presence: true
  validates :level, inclusion: { in: LEVELS }
end
