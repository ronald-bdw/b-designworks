class AuthPhoneCodeSerializer < ApplicationSerializer
  attributes :id, :phone_registered

  def phone_registered
    object.user.present?
  end
end
