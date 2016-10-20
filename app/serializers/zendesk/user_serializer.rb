module Zendesk
  class UserSerializer < ApplicationSerializer
    attributes :integrations, :notifications

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
  end
end
