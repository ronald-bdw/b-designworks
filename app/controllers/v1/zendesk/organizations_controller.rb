module V1
  module Zendesk
    class OrganizationsController < ApplicationController
      before_action :authorize_zendesk_app!

      expose(:provider, attributes: :provider_params, finder: :find_by_zendesk_id)

      def update
        provider.save

        respond_with provider
      end

      def fetch
        job = FetchOrganizationsFromZendeskJob.perform_later(params[:notify_email])

        respond_with job
      end

      private

      def provider_params
        params
          .require(:organization)
          .permit(:name, :priority, :first_popup_message, :second_popup_message)
      end
    end
  end
end
