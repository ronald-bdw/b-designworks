class User < ActiveRecord::Base
  acts_as_token_authenticatable
  mount_uploader :avatar, AvatarUploader

  devise :registerable, :trackable

  has_one :auth_phone_code, dependent: :destroy
  has_one :subscription, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :fitness_tokens, dependent: :destroy
  has_many :daily_steps, dependent: :destroy

  belongs_to :provider
  belongs_to :previous_provider, class_name: "Provider"

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: { types: %i(mobile), possible: true }, uniqueness: { case_sensitive: false }

  delegate :thumb, to: :avatar, prefix: true, allow_nil: true
  delegate :name, to: :provider, prefix: true, allow_nil: true

  scope :by_provider, ->(orgs_ids) { where(provider_id: orgs_ids) }

  def zendesk_url
    "https://pearupcoach.zendesk.com/agent/users/" + zendesk_id
  end
end
