RSpec::Matchers.define :be_a_user_representation do |user|
  match do |json|
    response_attributes = user.sliced_attributes %w(
      id
      first_name
      last_name
      authentication_token
      email
      phone_number
    )

    custom_keys = %w(last_healthkit_activity integrations)

    expect(json).to be
    expect(json).to include_attributes(response_attributes)
    expect(json).to include(*custom_keys)
  end
end
