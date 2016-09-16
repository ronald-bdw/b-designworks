module V1
  class UsersCollectionController < ApplicationController
    before_action :authorize_zendesk_app!

    def create
      result = Users::CreateFromFile.call(file: params[:file])
      status = result.success? ? :created : :unprocessable_entity

      render nothing: true, status: status
    end
  end
end
