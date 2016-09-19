module V1
  class UsersCollectionController < ApplicationController
    before_action :authorize_zendesk_app!

    def create
      result = Users::CreateFromFile.call(file: params[:file].tempfile)

      if result.success?
        render nothing: true, status: :created
      else
        respond_with result.invalid_users, status: :unprocessable_entity
      end
    end
  end
end
