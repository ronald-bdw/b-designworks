RSpec::Matchers.define :be_a_provider_representation do
  match do |json|
    attributes = %w(id name priority first_popup_message second_popup_message subscriber)

    expect(json.keys).to match_array(attributes)
  end
end
