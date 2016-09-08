class UserSerializer < ApplicationSerializer
  attributes :id,
    :first_name,
    :last_name,
    :phone_number,
    :authentication_token,
    :email,
    :avatar,
    :last_activity

  def avatar
    {
      original: object.avatar_url,
      thumb: object.avatar_thumb.url
    }
  end

  def last_activity
    ActivitySerializer.new(object.activities.order_by_finished_at.last).attributes
  end
end
