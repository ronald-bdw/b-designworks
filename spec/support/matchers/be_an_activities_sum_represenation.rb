RSpec::Matchers.define :be_an_activities_sum_representation do
  match do |json|
    attributes = %w(date steps_count)

    expect(json).to be_instance_of(Array)
    expect(json.first.keys).to match_array(attributes)
  end
end
