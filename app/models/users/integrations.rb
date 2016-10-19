module Users
  class Integrations
    attr_reader :user, :skipped_integrations

    def initialize(user, options = {})
      @user = user
      @skipped_integrations = options[:skipped_integrations] || []
    end

    def to_a
      integrations_list.map do |source_name|
        if respond_to?(source_name, :include_private)
          self.send(source_name)
        else
          integration_status(source_name)
        end
      end
    end

    private

    def integrations_list
      Activity.sources.keys - skipped_integrations
    end

    def integration_status(source_name)
      fitness_token = user.fitness_tokens.send(source_name).first

      {
        fitness_token_id: fitness_token&.id,
        name: source_name.humanize,
        status: fitness_token.present?
      }
    end

    def healthkit
      {
        name: "HealthKit",
        status: user.activities.healthkit.present?
      }
    end
  end
end
