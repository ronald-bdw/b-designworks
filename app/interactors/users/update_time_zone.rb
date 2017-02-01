module Users
  class UpdateTimeZone
    include Interactor

    delegate :user, :time_zone, to: :context

    def call
      user.time_zone = timezone
      UpdateZendeskAccount.call(user: user, photo: nil)
    end

    private

    def timezone
      ActiveSupport::TimeZone::MAPPING.select { |_k, v| v == time_zone }.keys.first
    end
  end
end
