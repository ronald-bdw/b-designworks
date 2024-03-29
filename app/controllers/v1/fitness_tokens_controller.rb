module V1
  class FitnessTokensController < ApplicationController
    wrap_parameters :fitness_token, include: %i(authorization_code source)

    acts_as_token_authentication_handler_for User

    expose(:fitness_token, attributes: :fitness_token_params)
    expose(:fitness_tokens, ancestor: :current_user)

    def create
      result = FitnessTokens::Create.call(
        fitness_token: fitness_token
      )

      respond_with result.fitness_token
    end

    def destroy
      self.fitness_token = current_user.fitness_tokens.find_by(id: params[:id])
      fitness_token.destroy if fitness_token.present?

      head :ok
    end

    private

    def fitness_token_params
      params.require(:fitness_token).permit(
        :source,
        :authorization_code
      )
    end
  end
end
