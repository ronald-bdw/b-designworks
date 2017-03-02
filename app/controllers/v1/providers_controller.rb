module V1
  class ProvidersController < ApplicationController
    expose(:providers, &:not_subscriber)

    def index
      respond_with providers
    end
  end
end
