class UserSerializer < ApplicationSerializer
  attributes :id,
    :first_name,
    :last_name,
    :phone_number,
    :authentication_token,
    :email,
    :avatar

  Activity.sources.keys.each do |source_name|
    attr_name = "last_#{source_name}_activity".to_sym
    attribute attr_name

    define_method attr_name do
      activity = activities_by(source_name.to_sym).last
      ActivitySerializer.new(activity).attributes if activity
    end
  end

  def avatar
    {
      original: object.avatar_url,
      thumb: object.avatar_thumb.url
    }
  end

  private

  def activities_by(scope)
    object.activities.send(scope).order_by_finished_at
  end
end
