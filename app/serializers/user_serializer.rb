class UserSerializer < ApplicationSerializer
  attributes :id,
    :first_name,
    :last_name,
    :phone_number,
    :authentication_token,
    :email,
    :avatar,
    :last_healthkit_activity,
    :integrations

  belongs_to :provider

  def last_healthkit_activity
    activity = object.activities.healthkit.order_by_finished_at.last

    ActivitySerializer.new(activity).attributes if activity
  end

  def integrations
    Users::IntegrationsSerializer.new(object).attributes
  end

  def avatar
    {
      original: object.avatar_url,
      thumb: object.avatar_thumb.url
    }
  end
end
