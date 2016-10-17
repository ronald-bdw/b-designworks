module Users
  class IntegrationsSerializer < ApplicationSerializer
    FitnessToken.sources.keys.each do |source_name|
      attributes source_name.to_sym

      define_method source_name do
        object.fitness_tokens.send(source_name).present?
      end
    end
  end
end
