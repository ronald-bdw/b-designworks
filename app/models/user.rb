class User < ActiveRecord::Base
  acts_as_token_authenticatable
  mount_uploader :avatar, AvatarUploader

  devise :registerable, :trackable

  has_one :auth_phone_code, dependent: :destroy
  has_many :activities, dependent: :destroy
  belongs_to :provider

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: { types: %i(mobile) }, uniqueness: { case_sensitive: false }
  validates :provider, presence: true, allow_nil: true

  delegate :thumb, to: :avatar, prefix: true, allow_nil: true
end
