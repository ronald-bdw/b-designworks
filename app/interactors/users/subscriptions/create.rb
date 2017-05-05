module Users
  module Subscriptions
    class Create
      include Interactor

      delegate :user, :provider, to: :context

      def call
        if user.update(update_params)
          context.user = user
        else
          context.fail!
        end
      end

      private

      def update_params
        {
          second_popup_active: true,
          provider: provider,
          previous_provider: set_previous_provider
        }
      end

      def set_previous_provider
        return user.previous_provider if user.provider == provider

        user.provider
      end
    end
  end
end
