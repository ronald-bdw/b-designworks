module V1
  module Zendesk
    class TicketsController < ApplicationController
      def create
        result = ::Zendesk::BindTicketToUser.call(ticket_id: params[:ticket_id])

        render nothing: true, status: (result.success? ? :created : :unprocessable_entity)
      end
    end
  end
end
