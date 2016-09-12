RSpec::Matchers.define :be_a_user_representation do |user|
  match do |json|
    response_attributes = user.sliced_attributes %w(
      id
      first_name
      last_name
      authentication_token
      email
      phone_number
      last_healthkit_activity
      last_googlefit_activity
      last_fitbit_activity
    )

    expect(json).to be
    expect(json).to include_attributes(response_attributes)
  end
end
