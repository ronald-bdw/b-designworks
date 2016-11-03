class AuthPhoneCodeSerializer < ApplicationSerializer
  attributes :id, :phone_registered, :provider

  def phone_registered
    object.user.present?
  end

  def provider
    object.user&.provider_name
  end
end
