require "rails_helper"
require "rspec_api_documentation/dsl"

resource "FitnessTokens" do
  header "Accept", "application/json"

  let!(:user) { create(:user) }

  before do
    setup_authentication_header(user)
  end

  post "/v1/fitness_tokens" do
    let(:user_id) { user.id }
    let(:access_token_response) { double :response, status: 200, body: access_token_params }

    subject(:response) { json_response_body }

    before do
      allow_any_instance_of(Faraday::Connection)
        .to receive(:post).and_return(access_token_response)
    end

    with_options required: true do |required|
      required.parameter :source, "(string)[googlefit|fitbit] Source of fitness token"
      required.parameter :authorization_code, "(string) The authorization code"
    end

    context "with valid params" do
      context "for fitbit integration" do
        let(:access_token_params) do
          {
            access_token: "access_token_from_fitbit",
            expires_in: 28_800,
            refresh_token: "refresh_token_from_fitbit",
            scope: "activity",
            token_type: "Bearer",
            user_id: "fitbit_user_id"
          }.to_json
        end
        let(:params) do
          {
            authorization_code: "my token",
            source: "fitbit"
          }
        end

        example_request "Save user fitness token" do
          fitness_token = user.fitness_tokens.last
          expect(response_status).to eq 201
          expect(fitness_token.token).to eq "access_token_from_fitbit"
          expect(fitness_token.refresh_token).to eq "refresh_token_from_fitbit"
        end
      end

      context "for googlefit integration", document: false do
        let(:access_token_params) do
          {
            access_token: "access_token_from_googlefit",
            expires_in: 28_800,
            refresh_token: "refresh_token_from_googlefit",
            token_type: "Bearer"
          }.to_json
        end
        let(:params) do
          {
            authorization_code: "my token",
            source: "googlefit"
          }
        end

        example_request "Save user fitness token" do
          fitness_token = user.fitness_tokens.last

          expect(response_status).to eq 201
          expect(fitness_token.token).to eq "access_token_from_googlefit"
          expect(fitness_token.refresh_token).to eq "refresh_token_from_googlefit"
        end
      end
    end

    context "with invalid params", document: false do
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

      let(:params) { { source: "fitbit" } }

      example_request "Can't save user fitness token" do
        expect(response_status).to eq 422
        error = { token: [{ body: ["Something went wrong!"] }] }.deep_stringify_keys
        expect(response["error"]["validations"]).to eq(error)
      end
    end
  end

  delete "/v1/fitness_tokens/:id" do
    parameter :id, "Fitness token id", required: true

    let(:fitness_token) { create :fitness_token, user: user }
    let(:id) { fitness_token.id }

    example_request "Delete fitness token" do
      expect(status).to eq(200)
    end
  end
end
