class UserSerializer < ApplicationSerializer
  attributes :id,
    :zendesk_id,
    :first_name,
    :last_name,
    :phone_number,
    :authentication_token,
    :email,
    :avatar,
    :last_healthkit_activity,
    :integrations,
    :first_popup_active,
    :second_popup_active,
    :trial_used

  belongs_to :provider

  def last_healthkit_activity
    activity = object.activities.healthkit.order_by_finished_at.last

    ActivitySerializer.new(activity).attributes if activity
  end

  def integrations
    Users::Integrations.new(object, skipped_integrations: ["healthkit"]).to_a
  end

  def avatar
    {
      original: object.avatar_url,
      thumb: object.avatar_thumb.url
    }
  end
end
