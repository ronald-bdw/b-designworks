module Zendesk
  class HandleUserErrors
    include Interactor

    delegate :zendesk_user, to: :context

    def call
      context.errors = parse_errors
    end

    private

    def parse_errors
      errors = {}

      zendesk_user.errors.each do |key, value|
        message = I18n.t("zendesk.errors.#{value[0]['error'].underscore}", default: "is invalid")
        errors[key.to_sym] = [message]
      end

      errors
    end
  end
end
