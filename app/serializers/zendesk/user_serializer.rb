module Zendesk
  class UserSerializer < ApplicationSerializer
    attributes :integrations, :notifications, :subscription

    def integrations
      Users::Integrations.new(object).to_a
    end

    def notifications
      Notification.kinds.keys.map do |notification_kind|
        {
          name: notification_kind.humanize,
          status: object.notifications.send(notification_kind).present?
        }
      end
    end

    def subscription
      {
        plan_name: subscription_plan_name,
        status: subscription_status
      }
    end

    private

    def subscription_plan_name
      object_subscription&.plan_name&.humanize || "Provider"
    end

    # rubocop:disable Style/SafeNavigation
    def subscription_status
      if object_subscription
        object_subscription.active
      else
        object.provider.present?
      end
    end
    # rubocop:enable Style/SafeNavigation

    def object_subscription
      object.subscription
    end
  end
end
