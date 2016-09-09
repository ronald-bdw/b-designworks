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
      activities_sum_params = params.slice(:count, :period).merge(activities: user.activities)

      ActivitiesSum.create(activities_sum_params.symbolize_keys)
    end

    def user
      @user ||= User.find_by(zendesk_id: params[:zendesk_id])
    end

    def error
      RailsApiFormat::Error.new(status: :not_found, error: I18n.t("activity.errors.user.not_found"))
    end
  end
end
