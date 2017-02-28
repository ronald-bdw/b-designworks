module V1
  module Zendesk
    class UsersStepsExportsController < ApplicationController
      #before_action :authorize_zendesk_app!

      expose :provider, finder: :find_by_zendesk_id, finder_parameter: :organization_id

      def create
        result = ::Users::StepsExport.call(provider: provider)
        binding.pry

        send_file("#{Rails.root}/export.xls", filename: 'export1.xls', type:  "application/vnd.ms-excel")
      end
    end
  end
end
