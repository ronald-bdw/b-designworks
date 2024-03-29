module RailsApiFormat
  module Matchers
    extend RSpec::Matchers::DSL

    def json_present?(json)
      json.present? && json.include?("error")
    end

    def status_present?(json, error)
      json["error"]["status"] == error.status
    end

    def error_present?(json, error)
      json["error"]["error"] == error.error
    end

    def validation_error_present?(json, error)
      validations = json["error"]["validations"]
      errors = validations.keys.find do |key|
        validations[key] == error.validations[key]
      end
      errors.present?
    end

    matcher :be_an_error_representation do |status, error|
      error = RailsApiFormat::Error.new(status: status, error: error)

      match do |json|
        json_present?(json) && status_present?(json, error) && error_present?(json, error)
      end
    end

    matcher :be_an_validation_error_representation do |status, validation_messages|
      error = RailsApiFormat::Error.new(status: status, validations: validation_messages)

      match do |json|
        json_present?(json) && status_present?(json, error) && validation_error_present?(json, error)
      end
    end
  end
end
