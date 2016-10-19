module Zendesk
  class UserSerializer < ApplicationSerializer
    attributes :integrations, :notifications

    def integrations
      integrations = [healthkit]

      FitnessToken.sources.keys.each do |source_name|
        integrations << integration_status(source_name)
      end

      integrations
    end

    def notifications
      Notification.kinds.keys.map do |notification_kind|
        {
          name: notification_kind.humanize,
          status: object.notifications.send(notification_kind).present?
        }
      end
    end

    private

    def integration_status(source_name)
      {
        name: source_name.humanize,
        status: object.fitness_tokens.send(source_name).present?
      }
    end

    def healthkit
      {
        name: "HealthKit",
        status: object.activities.healthkit.present?
      }
    end
  end
end
