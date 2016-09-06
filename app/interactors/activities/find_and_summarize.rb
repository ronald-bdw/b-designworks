module Activities
  class FindAndSummarize
    include Interactor

    delegate :params, to: :context

    def call
      context.fail!(error: error) if user.nil?

      context.activities = activities_sum
    end

    private

    def activities_sum
      ActivitiesSum.create(activities: user.activities, count: params[:count])
    end

    def user
      @user ||= User.find_by(phone_number: params[:user_phone_number])
    end

    def error
      RailsApiFormat::Error.new(status: :not_found, error: I18n.t("activity.errors.user.not_found"))
    end
  end
end
