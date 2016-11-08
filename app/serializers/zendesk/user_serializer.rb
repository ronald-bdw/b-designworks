module Zendesk
  class UserSerializer < ApplicationSerializer
    attributes :integrations, :notifications, :subscription_status

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

    def subscription_status
      object.subscription&.active
    end
  end
end
