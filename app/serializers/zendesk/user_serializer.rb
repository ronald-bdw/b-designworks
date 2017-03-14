module Zendesk
  class UserSerializer < ApplicationSerializer
    PROVIDERS = %w(provider previous_provider).freeze

    attributes :integrations, :notifications, :subscription, :device, :provider_name, :previous_provider_name

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

    PROVIDERS.each do |provider|
      define_method "#{provider}_name" do
        return nil unless object.send("#{provider}_id")

        Provider.find(object.send("#{provider}_id")).name
      end
    end

    private

    def subscription_plan_name
      return "Provider" unless object_subscription&.plan_name&.humanize

      "#{object_subscription.plan_name.humanize}#{purchased_date}"
    end

    def purchased_date
      return "" unless object_subscription.purchased_at

      " (#{object_subscription.purchased_at})"
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
