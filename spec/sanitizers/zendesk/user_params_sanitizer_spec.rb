require "rails_helper"

describe Zendesk::UserParamsSanitizer do
  subject(:sanitizer) { described_class.new(params) }

  describe "#sanitized_params" do
    context "with multiple params" do
      let(:params) do
        ActionController::Parameters.new(
          user: {
            name: "Example User",
            email: "user@example.com",
            first_popup_active: "true"
          }
        )
      end

      let(:expected_params) do
        {
          first_name: "Example",
          last_name: "User",
          email: "user@example.com",
          first_popup_active: "true"
        }
      end

      it "provides sanitized params" do
        expect(sanitizer.sanitized_params).to include(expected_params)
      end
    end

    context "without name paramter" do
      let(:params) do
        ActionController::Parameters.new(
          user: {
            email: "user@example.com",
            first_popup_active: "true"
          }
        )
      end

      let(:expected_params) do
        {
          email: "user@example.com",
          first_popup_active: "true"
        }
      end

      it "provides sanitized params" do
        expect(sanitizer.sanitized_params).to include(expected_params)
      end
    end
  end
end
