require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users" do
  header "Accept", "application/json"

  before do
    allow(ZendeskAPI::User).to receive(:create).and_return(zendesk_user)
    allow(ZendeskAPI::User).to receive(:update!).and_return(zendesk_user)
  end

  let(:zendesk_user) { double :zendesk_user, id: 1 }
  let(:auth_phone_code) { create :auth_phone_code, expire_at: 2.days.from_now }
  let(:user_params) do
    attributes_for(:user).slice(
      :first_name,
      :last_name,
      :email,
      :phone_number
    )
  end

  subject(:response) { json_response_body }

  post "/v1/users" do
    parameter :first_name, "First name", required: true
    parameter :last_name, "Last name", required: true
    parameter :email, "Email", required: true
    parameter :phone_number, "Phone number", required: true
    parameter :auth_phone_code_id, "Auth phone code id", required: true
    parameter :sms_code, "Sms code", required: true

    context "with valid params" do
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "create user with phone number" do
        user = User.last

        expect(user.auth_phone_code).to eq(auth_phone_code)
        expect(response["user"]).to be_a_user_representation(User.last)
      end
    end

    context "with invalid phone number" do
      let(:error_message) { { "phone_number" => ["is invalid"] } }
      let(:params) do
        {
          user: user_params.except(:phone_number),
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "create user without phone number" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, error_message)
      end
    end

    context "with invalid sms code" do
      let(:error_message) { { "sms_code" => ["is invalid"] } }
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: "invalid_code"
        }
      end

      example_request "create user with invalid sms code" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, error_message)
      end
    end

    context "with expired sms code" do
      let(:error_message) { { "sms_code" => ["is expired"] } }
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      let(:auth_phone_code) { create :auth_phone_code, expire_at: 5.minutes.ago }

      example_request "create user with invalid sms code" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, error_message)
      end
    end
  end

  put "/v1/users/:id" do
    parameter :first_name, "First name", required: true
    parameter :last_name, "Last name", required: true
    parameter :email, "Email", required: true
    parameter :phone_number, "Phone number", required: true
    parameter :avatar, "Avatar"

    let(:user) { create :user }
    let(:id) { user.id }

    it_behaves_like(
      "a method that requires an authentication",
      "user",
      "updating"
    )

    context "with authentication token" do
      before { setup_authentication_header(user) }

      let(:avatar) { fixture_file_upload "spec/fixtures/files/avatar.jpg", "image/jpg" }
      let(:user_json) { response["user"] }

      let(:user_params) do
        attributes_for(:user).slice(
          :first_name,
          :last_name,
          :email,
          :phone_number
        ).merge(avatar: avatar)
      end

      let(:params) { { user: user_params.merge(avatar: avatar) } }

      example_request "upload user avatar" do
        expect(user_json["avatar"]["original"]).to include(avatar.original_filename)
        expect(user_json["avatar"]["thumb"]).to include(avatar.original_filename)
        expect(user_json).to be_a_user_representation(User.last)
      end
    end
  end
end
