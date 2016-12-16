module Users
  module Subscriptions
    class Expire
      include Interactor

      delegate :user, to: :context

      def call
        context.fail!(error: error) if subscription.nil?

        subscription.expire!
      end

      private

      def subscription
        @subscription ||= user.subscription
      end

      def error
        RailsApiFormat::Error.new(
          status: :not_found,
          error: I18n.t("subscriptions.errors.not_found")
        )
      end
    end
  end
end
