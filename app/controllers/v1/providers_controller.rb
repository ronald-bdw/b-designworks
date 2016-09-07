module V1
  class ProvidersController < ApplicationController
    expose(:providers)

    def index
      respond_with providers
    end
  end
end
