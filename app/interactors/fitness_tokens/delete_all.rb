module FitnessTokens
  class DeleteAll
    include Interactor

    delegate :user, to: :context

    def call
      user&.fitness_tokens.delete_all
    end
  end
end
