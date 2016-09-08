require "rails_helper"

describe SaveActivityBulk do
  let(:user)        { create(:user) }
  let(:finished_at) { "2016-09-08 09:00:00 UTC".to_datetime }
  let(:interactor)  { described_class.call(params: params, user: user) }
  let(:params) do
    [
      { started_at: started_at, finished_at: finished_at, steps_count: 2000 },
      { started_at: 2.day.ago, finished_at: 1.day.ago, steps_count: 3000 }
    ]
  end

  context "with valid params" do
    let(:started_at) { "2016-09-07 09:00:00 UTC".to_datetime }

    it "creates activities with given params" do
      expect { interactor }.to change { Activity.count }.by(2)
    end
  end

  context "with invalid params" do
    let(:started_at)   { nil }
    let(:invalid_data) { "[{:started_at=>nil, :finished_at=>Thu, 08 Sep 2016 09:00:00 +0000, :steps_count=>2000}]" }
    let(:message)      { "Can't save activities: #{invalid_data}" }

    it "returns error message" do
      expect { interactor }.to change { Activity.count }.by(1)
      expect(interactor.message).to eq(message)
    end
  end
end
