require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Activities" do
  header "Accept", "application/json"

  let(:user)        { create(:user) }
  let(:started_at)  { 1.day.ago }
  let(:finished_at) { Time.zone.now }
  let(:steps_count) { 1000 }

  subject(:response) { json_response_body }

  before { setup_authentication_header(user) }

  post "/v1/activities" do
    with_options required: true do |required|
      required.parameter :started_at, "Period start"
      required.parameter :finished_at, "Period end"
      required.parameter :steps_count, "Steps count"
    end

    example_request "Save user activity with valid params" do
      expect(response_status).to eq 201
      expect(response["activity"]).to be_an_activity_representation(Activity.last)
    end

    example "Save user activity with invalid params", document: false do
      do_request(started_at: nil)
      error_message = { "started_at" => ["can't be blank"] }

      expect(response_status).to eq 422
      expect(response).to be_an_validation_error_representation(:unprocessable_entity, error_message)
    end
  end
end
