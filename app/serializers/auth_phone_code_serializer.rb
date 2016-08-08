class AuthPhoneCodeSerializer < ApplicationSerializer
  attributes :id, :phone_code, :expire_at, :phone_registered

  def phone_registered
    object.user.present?
  end
end
