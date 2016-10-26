require "rails_helper"

RSpec.describe FetchGooglefitActivityJob do
  describe ".perform" do
    before do
      allow(Time).to receive(:current).and_return(date)
    end

    let(:date) { Time.zone.parse("2016-01-01 10:00:00") }
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

    subject(:job) { described_class.perform_now }

    it "fetch activities for googlefit and save in activities" do
      expect { subject }.to change { user.activities.count }.by(6)
    end
  end
end
