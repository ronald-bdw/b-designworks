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
      if object.provider.present?
        "Provider"
      else
        object.subscription&.plan_name.humanize
      end
    end

    def subscription_status
      object.provider.present? || object.subscription&.active
    end
  end
end
