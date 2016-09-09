require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Activities" do
  header "Accept", "application/json"

  let(:user)       { create(:user) }
  let(:activities) { [attributes_for(:activity, started_at: started_at)] }

  subject(:response) { json_response_body }

  before { setup_authentication_header(user) }

  post "/v1/activities" do
    with_options required: true do |required|
      required.parameter :activities, "(Array) Collection of activity data"
      required.parameter :started_at, "(String) Period start for activity item"
      required.parameter :finished_at, "(String) Period end for activity item"
      required.parameter :steps_count, "(String) Steps count for activity item"
    end

    context "with valid params" do
      let(:started_at) { 2.day.ago }

      example "Save user activitites" do
        do_request(activities: activities)

        expect(response_status).to eq 201
      end
    end

    context "with invalid params", document: false do
      let(:started_at) { nil }

      example "Can't save user activities" do
        do_request(activities: activities)

        expect(response_status).to eq 422
      end
    end
  end

  get "/v1/activities" do
    before { create_list :activity, 5, user: user }

    parameter :count, "Number of days with activities"
    parameter :period, "Activities period"
    parameter :zendesk_id, "User zendesk id", required: true

    let(:zendesk_id) { user.zendesk_id }

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
