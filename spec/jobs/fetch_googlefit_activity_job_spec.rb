require "rails_helper"

RSpec.describe FetchGooglefitActivityJob do
  describe ".perform" do
    let!(:user) { create(:user) }
    let!(:fitness_token) do
      create(
        :fitness_token,
        source: "googlefit",
        token: "access_token_from_googlefit",
        refresh_token: "refresh_token_from_googlefit",
        user: user
      )
    end
    let(:fetched_activities) do
      JSON.parse(File.read("spec/fixtures/googlefit_user_activites.json"))
    end
    let(:fetched_activities_response) { double :response, status: 200, body: fetched_activities.to_json }

    subject(:job) { described_class.perform_now }

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:get).and_return(fetched_activities_response)
    end

    it "fetch activities for googlefit and save in activities" do
      expect { subject }.to change { user.activities.count }.by(6)
    end
  end
end
