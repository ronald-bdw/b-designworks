require "rails_helper"

describe SaveActivityBulk do
  let(:user)       { create(:user) }
  let(:activities) { [{ started_at: started_at, finished_at: 1.day.ago, steps_count: 2000 }] }
  let(:interactor) { described_class.call(activities: activities, user: user) }

  context "with valid params" do
    let(:started_at) { 2.day.ago }

    it "creates activities with given params" do
      expect { interactor }.to change { Activity.count }.by(1)
    end
  end

  context "with invalid params" do
    let(:started_at) { nil }
    let(:message)    { "Data is not valid" }

    it "returns error message" do
      expect { interactor }.not_to change { Activity.count }
      expect(interactor.message).to eq(message)
    end
  end
end
