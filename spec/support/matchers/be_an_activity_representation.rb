RSpec::Matchers.define :be_an_activity_representation do |activity|
  match do |json|
    response_attributes = activity.sliced_attributes %w(
      id
      started_at
      finished_at
      steps_count
    )

    expect(json).to be
    expect(json).to include_attributes(response_attributes)
  end
end
