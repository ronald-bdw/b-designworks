class AuthPhoneCode < ActiveRecord::Base
  belongs_to :user

  validates :phone_code, numericality: { only_integer: true }, length: { is: 4 }, presence: true
end
