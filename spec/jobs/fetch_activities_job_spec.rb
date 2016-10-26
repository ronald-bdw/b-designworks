require "rails_helper"

describe FetchActivitiesJob do
  describe ".perform" do
    before do
      create :fitness_token, :fitbit
      create :fitness_token, :googlefit
      allow(Time).to receive(:current).and_return(date)

      described_class.perform_now
    end

    let(:date) { Time.zone.parse("2016-01-01 10:00:00") }

    it "creates googlefit and fitbit activities" do
      expect(Activity.fitbit.count).to eq(1)
      expect(Activity.googlefit.count).to eq(6)
    end
  end
end
