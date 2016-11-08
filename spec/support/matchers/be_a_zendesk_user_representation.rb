RSpec::Matchers.define :be_a_zendesk_user_representation do
  match do |json|
    keys = %w(integrations notifications subscription_status)

    expect(json).to be
    expect(json).to include(*keys)
  end
end
