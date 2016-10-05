class FetchUsersFromZendeskJob < ActiveJob::Base
  queue_as :default

  def perform
    ZENDESK_CLIENT.users.all do |user|
      create_or_update_user(user) if zendesk_user_valid?(user)
    end
  end

  private

  def create_or_update_user(zendesk_user)
    user = User.find_or_initialize_by(phone_number: zendesk_user.phone)
    splitted_name = Users::SplittedName.new(zendesk_user.name)

    user.first_name = splitted_name.first_name
    user.last_name = splitted_name.last_name || "LastName"
    user.email = zendesk_user.email
    user.zendesk_id = zendesk_user.id
    user.save
  end

  def zendesk_user_valid?(zendesk_user)
    zendesk_user.role.name == "end-user" && zendesk_user.phone.present?
  end
end
