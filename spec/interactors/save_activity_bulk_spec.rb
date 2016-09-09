require "rails_helper"

describe SaveActivityBulk do
  let(:user)        { create(:user) }
  let(:finished_at) { "2016-09-08 09:00:00 UTC".to_datetime }
  let(:interactor)  { described_class.call(params: params, user: user) }
  let(:params) do
    [
      attributes_for(:activity, started_at: started_at, finished_at: finished_at),
      attributes_for(:activity)
    ]
  end

  context "with valid params" do
    let(:started_at) { "2016-09-07 09:00:00 UTC".to_datetime }

    it "creates activities" do
      expect { interactor }.to change { Activity.count }.by(2)
    end
  end

  context "with invalid params" do
    let(:started_at)   { nil }
    let(:invalid_data) { [attributes_for(:activity, started_at: nil, finished_at: finished_at)] }
    let(:message)      { "Can't save activities: #{invalid_data}" }

    it "creates only valid activities" do
      expect { interactor }.to change { Activity.count }.by(1)
      expect(interactor.error).to be_kind_of(RailsApiFormat::Error)
    end
  end
end
