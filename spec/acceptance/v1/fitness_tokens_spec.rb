require "rails_helper"
require "rspec_api_documentation/dsl"

resource "FitnessTokens" do
  header "Accept", "application/json"

  let!(:user) { create(:user) }
  let(:user_id) { user.id }
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
  let(:access_token_response) { double :response, status: 200, body: access_token_params }

  subject(:response) { json_response_body }

  before do
    allow_any_instance_of(Faraday::Connection)
      .to receive(:post).and_return(access_token_response)

    setup_authentication_header(user)
  end

  post "/v1/fitness_tokens" do
    with_options required: true do |required|
      required.parameter :source, "(string)[googlefit|fitbit] Source of fitness token"
      required.parameter :token, "(string) The token"
    end

    context "with valid params" do
      context "for fitbit integration" do
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

      context "for googlefit integration" do
        let(:params) do
          {
            token: "my token",
            source: "googlefit"
          }
        end

        example_request "Save user fitness token" do
          fitness_token = user.fitness_tokens.last

          expect(response_status).to eq 201
          expect(fitness_token.token).to eq "my token"
          expect(fitness_token.refresh_token).to be_nil
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
        expect(response["error"]["validations"]).to eq({ token: ["is invalid"] }.stringify_keys)
      end
    end
  end
end
