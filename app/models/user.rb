class User < ActiveRecord::Base
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
    :recoverable, :trackable, :validatable

  has_one :auth_phone_code, dependent: :destroy

  validates :phone_number, presence: true
end
