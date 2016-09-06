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

  get "/v1/activities" do
    before { create_list :activity, 5, user: user }

    parameter :count, "Number of days with activities"
    parameter :user_phone_number, "User phone number"

    let(:user_phone_number) { user.phone_number }

    context "with authorization header" do
      header("X-Auth-Token", ZENDESK_PEARUP_API_TOKEN)

      example_request "returns activities list grouped by day" do
        expect(response_status).to eq(200)
        expect(response).to be_an_activities_sum_representation
      end
    end

    example "returns activities list grouped by day", document: false do
      do_request

      expect(response_status).to eq(401)
    end
  end
end
