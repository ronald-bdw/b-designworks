RSpec::Matchers.define :be_a_provider_representation do
  match do |json|
    attributes = %w(id name)

    expect(json.keys).to match_array(attributes)
  end
end
