class User < ActiveRecord::Base
  acts_as_token_authenticatable
  mount_uploader :avatar, AvatarUploader

  devise :registerable, :trackable

  has_one :auth_phone_code, dependent: :destroy
  has_one :subscription, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :fitness_tokens, dependent: :destroy

  belongs_to :provider

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: { types: %i(mobile), possible: true }, uniqueness: { case_sensitive: false }

  delegate :thumb, to: :avatar, prefix: true, allow_nil: true
end
