module Zendesk
  class HandleUserErrors
    include Interactor

    delegate :user_errors, to: :context

    def call
      context.errors = parse_errors
    end

    private

    def parse_errors
      user_errors.reduce({}) do |errors, (key, value)|
        message = I18n.t("zendesk.errors.#{value[0]['error'].underscore}", default: "is invalid")
        errors[key.to_sym] = [message]
        errors
      end
    end
  end
end
