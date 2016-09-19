module V1
  class FitnessTokensController < ApplicationController
    wrap_parameters :fitness_token

    acts_as_token_authentication_handler_for User, only: :create

    expose(:fitness_token, attributes: :fitness_token_params)
    expose(:fitness_tokens, ancestor: :current_user)

    def create
      result = FitnessTokens::Create.call(
        fitness_token: fitness_token,
        device_type: request.user_agent
      )

      respond_with result.fitness_token
    end

    private

    def fitness_token_params
      params.require(:fitness_token).permit(
        :source,
        :token,
        :authorization_code
      )
    end
  end
end
