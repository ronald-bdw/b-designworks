module V1
  class SubscriptionsController < ApplicationController
    wrap_parameters :subscription, include: %i(plan_name expires_at active)

    acts_as_token_authentication_handler_for User

    expose(:subscription) { current_user.subscription || current_user.build_subscription }

    def create
      subscription.update(subscription_params)

      respond_with subscription
    end

    private

    def subscription_params
      params.require(:subscription).permit(
        :plan_name,
        :expires_at,
        :active
      )
    end
  end
end
