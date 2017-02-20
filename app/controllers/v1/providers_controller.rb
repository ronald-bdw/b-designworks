module V1
  class ProvidersController < ApplicationController
    expose(:providers) { |default| default.not_subscriber }

    def index
      respond_with providers
    end
  end
end
