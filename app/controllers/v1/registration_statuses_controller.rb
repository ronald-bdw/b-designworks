module V1
  class RegistrationStatusesController < ApplicationController
    def create
      registration_status = RegistrationStatus.new(params[:phone_number])

      respond_with registration_status
    end
  end
end
