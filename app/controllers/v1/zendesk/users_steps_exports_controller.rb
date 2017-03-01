module V1
  module Zendesk
    class UsersStepsExportsController < ApplicationController
      before_action :authorize_zendesk_app!

      expose :provider, finder: :find_by_zendesk_id, finder_parameter: :organization_id

      def create
        result = ::Users::StepsExport.call(provider: provider, year: params[:year])

        render json: { file: result.file }
      end
    end
  end
end
