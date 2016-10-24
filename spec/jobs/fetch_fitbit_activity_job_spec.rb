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

    subject(:job) { described_class.perform_now }

    it "fetch activities for fitbit and save in activities" do
      expect { subject }.to change { user.activities.count }.by(1)
    end
  end
end
