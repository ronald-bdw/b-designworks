require "rails_helper"

describe FitnessTokens::FetchFitbitToken do
  describe ".call" do
    subject(:interactor) do
      described_class.call(
        fitness_token: fitness_token,
        device_type: "android"
      )
    end

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:post).and_return(access_token_response)
      subject
    end

    context "with valid params" do
      let(:fitness_token) do
        build(
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
        expect(subject.fitbit_access_token).to eq access_token_params[:access_token]
        expect(subject.fitbit_refresh_token).to eq access_token_params[:refresh_token]
      end
    end

    context "with invalid params" do
      let(:fitness_token) do
        build(
          :fitness_token,
          source: "fitbit",
          token: nil,
          refresh_token: nil
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
        expect(fitness_token.token).to be_nil
        expect(fitness_token.refresh_token).to be_nil
        expect(fitness_token.errors.full_messages).to eq ["Token is invalid"]
      end
    end
  end
end
