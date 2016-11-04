class FetchUsersFromZendeskJob < ActiveJob::Base
  queue_as :default

  def perform(notify_email = nil)
    phone_numbers = []

    ZENDESK_CLIENT.users.all do |user|
      if zendesk_user_valid?(user)
        phone_numbers << user.phone
        create_or_update_user(user)
      end
    end

    delete_unnecessary_users(phone_numbers.compact)

    send_notify_email(notify_email) if notify_email
  end

  private

  def create_or_update_user(zendesk_user)
    user = User.find_or_initialize_by(phone_number: zendesk_user.phone)
    splitted_name = Users::SplittedName.new(zendesk_user.name)

    user.provider = Provider.default
    user.first_name = splitted_name.first_name
    user.last_name = splitted_name.last_name || "LastName"
    user.email = zendesk_user.email
    user.zendesk_id = zendesk_user.id
    user.save
  end

  def zendesk_user_valid?(zendesk_user)
    zendesk_user.role.name == "end-user" && zendesk_user.phone.present? && zendesk_user.organization_id.present?
  end

  def send_notify_email(email)
    ZendeskMailer.users_synchronized(email).deliver_now
  end

  def delete_unnecessary_users(phone_numbers)
    User.where.not(phone_number: phone_numbers).map(&:destroy) if phone_numbers.present?
  end
end
