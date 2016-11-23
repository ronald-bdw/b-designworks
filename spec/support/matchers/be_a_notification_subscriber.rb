RSpec::Matchers.define :be_a_notification_subscriber_representation do |notification_subscriber|
  match do |json|
    response_attributes = notification_subscriber.sliced_attributes %w(
      id
      email
      notification_types
    )

    expect(json).to be
    expect(json).to include_attributes(response_attributes)
  end
end
