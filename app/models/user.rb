class User < ActiveRecord::Base
  acts_as_token_authenticatable

  devise :registerable, :trackable

  has_one :auth_phone_code, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :phone_number, presence: true
end
