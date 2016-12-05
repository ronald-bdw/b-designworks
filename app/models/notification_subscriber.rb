class NotificationSubscriber < ActiveRecord::Base
  NOTIFICATION_TYPES = %w(first_user_login registration_complete).freeze

  validates :email,
    presence: true,
    uniqueness: true,
    format: Devise.email_regexp

  validates :notification_types, presence: true
  validate :notification_types_should_be_valid

  scope :with_type, ->(type) { where("? = ANY(notification_types)", type) }

  private

  def notification_types_should_be_valid
    return unless notification_types.find { |type| !NOTIFICATION_TYPES.include?(type) }

    errors.add :notification_types, I18n.t("notification_subscriber.errors.notification_types")
  end
end
