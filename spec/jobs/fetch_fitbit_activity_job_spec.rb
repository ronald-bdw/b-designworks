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
      [
        {
          "dateTime" => Date.today.strftime("%Y-%m-%d"),
          "value" => "0"
        }
      ]
    end

    subject(:job) { described_class.perform_now }

    before do
      allow(
        FitnessTokens::FetchActivity
      ).to receive(:call).and_return(double(:context, success?: true, steps: fetched_activities))
    end

    it "fetch activities for fitbit and save in activities" do
      expect { subject }.to change { user.activities.count }.by(1)
    end
  end
end
