class User < ActiveRecord::Base
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
    :recoverable, :trackable

  has_one :auth_phone_code, dependent: :destroy

  validates :email, :full_name, :phone_number, presence: true

  accepts_nested_attributes_for :auth_phone_code
end
