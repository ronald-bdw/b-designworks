require "rails_helper"

describe FitnessTokens::GooglefitRequest do
  describe ".fetch_token" do
    subject(:googlefit_request) do
      described_class.new(authorization_code: "auth code from googlefit").fetch_token
    end

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:post).and_return(access_token_response)
      googlefit_request.success?
    end

    context "with valid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "googlefit",
          authorization_code: "auth code from googlefit"
        )
      end

      let(:access_token_params) do
        {
          access_token: "access_token_from_googlefit",
          expires_in: 28_800,
          refresh_token: "refresh_token_from_googlefit",
          scope: "activity",
          token_type: "Bearer"
        }
      end

      let(:access_token_response) { double :response, status: 200, body: access_token_params.to_json }

      it "assigns token and refresh_token" do
        expect(googlefit_request.access_token).to eq access_token_params[:access_token]
      end
    end

    context "with invalid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "googlefit"
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
        message = { body: ["Something went wrong!"] }
        expect(googlefit_request.errors.messages).to eq message
      end
    end
  end

  describe ".fetch_activities" do
    subject(:googlefit_request) do
      described_class.new(
        token: "token from googlefit",
        path: "activities_path_from_env"
      ).fetch_activities
    end

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:get).and_return(fetched_activities_response)
    end

    context "with valid params" do
      let(:fitness_token) do
        create(
          :fitness_token,
          source: "googlefit",
          authorization_code: "auth code from googlefit"
        )
      end
      let(:fetched_activities) do
        JSON.parse(File.read("spec/fixtures/googlefit_user_activites.json"))
      end
      let(:fetched_activities_response) { double :response, status: 200, body: fetched_activities.to_json }

      it "assigns token and refresh_token" do
        expect(subject.steps).to eq fetched_activities.deep_stringify_keys["point"]
      end
    end
  end
end
