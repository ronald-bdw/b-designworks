require "rails_helper"

describe FitnessTokens::FitbitRequest do
  describe ".fetch_token" do
    subject(:fitbit_request) do
      described_class.new(
        authorization_code: "auth code from fitbit",
        path: "token_path_from_env"
      )
    end

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:post).and_return(access_token_response)
      subject.fetch_token
    end

    context "with valid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "fitbit",
          authorization_code: "auth code from fitbit"
        )
      end

      let(:access_token_params) do
        {
          access_token: "access_token_from_fitbit",
          expires_in: 28_800,
          refresh_token: "refresh_token_from_fitbit",
          scope: "activity",
          token_type: "Bearer",
          user_id: "fitbit_user_id"
        }
      end

      let(:access_token_response) { double :response, status: 200, body: access_token_params.to_json }

      it "assigns token and refresh_token" do
        expect(subject.response).to eq access_token_params.stringify_keys
      end
    end

    context "with invalid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "fitbit"
        )
      end

      let(:access_token_response) do
        double(
          :response,
          status: 422,
          body: {
            errors: [{
              errorType: "invalid_request",
              message: "Missing parameters: code"
            }],
            success: false
          }.to_json
        )
      end

      it "does not assigns token and refresh_token" do
        expect(subject.errors).to eq "is invalid"
      end
    end
  end

  describe ".fetch_activities" do
    subject(:fitbit_request) do
      described_class.new(
        token: "token from fitbit",
        path: "activities_path_from_env"
      )
    end

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:post).and_return(fetched_activities_response)
      subject.fetch_token
    end

    context "with valid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "fitbit",
          authorization_code: "auth code from fitbit"
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
        }
      end
      let(:fetched_activities_response) { double :response, status: 200, body: fetched_activities.to_json }

      it "assigns token and refresh_token" do
        expect(subject.response).to eq fetched_activities.deep_stringify_keys
      end
    end

    context "with invalid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "fitbit"
        )
      end

      let(:fetched_activities_response) do
        double(
          :response,
          status: 422,
          body: {
            errors: [{
              errorType: "invalid_client",
              message: "Invalid authorization header format."
            }],
            success: false
          }.to_json
        )
      end

      it "does not assigns token and refresh_token" do
        expect(subject.errors).to eq "is invalid"
      end
    end
  end
end
