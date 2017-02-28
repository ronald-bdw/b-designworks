module Zendesk
  class UserParamsSanitizer
    attr_reader :params
    private :params

    def initialize(params)
      @params = params
    end

    def sanitized_params
      permitted_params.merge(splitted_name)
    end

    private

    def permitted_params
      @permitted_params ||= params
                            .require(:user)
                            .permit(:email, :first_popup_active, :second_popup_active)
    end

    def splitted_name
      return {} unless params[:user] && params[:user][:name]

      Users::SplittedName.new(params[:user][:name]).to_hash
    end
  end
end
