module Users
  module Subscriptions
    class CreationManager
      include Interactor::Organizer

      organize Create, UpdateZendeskSubscriptions
    end
  end
end
