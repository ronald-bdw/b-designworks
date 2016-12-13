require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Activities" do
  header "Accept", "application/json"

  let(:user)       { create(:user) }
  let(:activity_params) { attributes_for(:activity, started_at: started_at) }
  let(:activities) { [activity_params] }

  subject(:response) { json_response_body }

  before { setup_authentication_header(user) }

  post "/v1/activities" do
    with_options required: true do |required|
      required.parameter :activities, "(array) Collection of activity data"
      required.parameter :started_at, "(string) The start time"
      required.parameter :finished_at, "(string) The date of the ending"
      required.parameter :steps_count, "(integer) Steps count of activity"
      required.parameter :source, "(string)[healthkit|googlefit|fitbit] Source of activity"
    end

    context "with valid params" do
      let(:started_at) { 2.day.ago }

      example "Save user activitites" do
        do_request(activities: activities)

        expect(response_status).to eq 201
      end
    end

    context "when user imports two same activities", document: false do
      let(:started_at) { "2016-01-01 10:00:00 GMT+3" }
      let(:activities) { [activity_params, activity_params] }

      example "Save only one activitity" do
        do_request(activities: activities)

        expect(Activity.count).to eq 1
        expect(response_status).to eq 201
      end
    end
  end

  get "/v1/activities" do
    before { create_list :activity, 5, user: user }

    parameter :count, "Number of days with activities"
    parameter :period, "Activities period"
    parameter :date, "Activities' date"
    parameter :zendesk_id, "User zendesk id", required: true
    parameter :source, "Activities' source"

    let(:zendesk_id) { user.zendesk_id }
    let(:source) { "healthkit" }

    context "with authorization header" do
      include_context "zendesk app"

      example_request "Get activities list" do
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
