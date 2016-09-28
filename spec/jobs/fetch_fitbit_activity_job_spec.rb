require "rails_helper"

RSpec.describe FetchFitbitActivityJob do
  describe ".perform" do
    let!(:user) { create(:user) }
    let!(:fitness_token) do
      create(
        :fitness_token,
        source: "fitbit",
        token: "access_token_from_fitbit",
        refresh_token: "refresh_token_from_fitbit",
        user: user
      )
    end
    let(:fetched_activities) do
      {
        "activities-steps": [
          {
            "dateTime": Date.today.strftime("%Y-%m-%d"),
            "value": "0"
          }
        ]
      }.to_json
    end
    let(:fetched_activities_response) { double :response, status: 200, body: fetched_activities }

    subject(:job) { described_class.perform_now }

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:get).and_return(fetched_activities_response)
    end

    it "fetch activities for fitbit and save in activities" do
      expect { subject }.to change { user.activities.count }.by(1)
    end
  end
end
