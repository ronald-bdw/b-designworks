module Users
  module Subscriptions
    class UpdateZendeskSubscriptions
      include Interactor

      delegate :user, to: :context
      delegate :provider, to: :user

      def call
        ZENDESK_CLIENT.users.update!(update_params)
      end

      private

      def update_params
        {
          id: user.zendesk_id,
          organization_id: provider.zendesk_id,
          user_fields: {
            first_popup_active: false,
            second_popup_active: false
          }
        }
      end
    end
  end
end
