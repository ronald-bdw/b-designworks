module Zendesk
  class HandleUserErrors
    include Interactor

    delegate :user_errors, to: :context

    def call
      context.errors = parse_errors
    end

    private

    def parse_errors
      errors = {}

      user_errors.each do |key, value|
        message = I18n.t("zendesk.errors.#{value[0]['error'].underscore}", default: "is invalid")
        errors[key.to_sym] = [message]
      end

      errors
    end
  end
end
