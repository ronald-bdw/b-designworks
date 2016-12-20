RSpec::Matchers.define :be_a_zendesk_user_representation do
  match do |json|
    keys = %w(integrations notifications subscription)

    expect(json).to be
    expect(json).to include(*keys)
  end
end
