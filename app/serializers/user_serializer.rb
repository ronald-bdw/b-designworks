class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :phone_number, :authentication_token, :email, :avatar

  def avatar
    {
      original: object.avatar_url,
      thumb: object.avatar_thumb.url
    }
  end
end
