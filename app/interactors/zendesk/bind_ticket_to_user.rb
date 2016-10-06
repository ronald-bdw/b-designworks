module Zendesk
  class BindTicketToUser
    include Interactor

    def call
      context.fail! if user.nil?

      old_requester = ticket.requester

      if update_ticket
        old_requester.destroy
      else
        context.fail!
      end
    end

    private

    def update_ticket
      ticket.requester_id = user.zendesk_id
      ticket.subject = "[PearUp] Conversation with #{user.first_name} #{user.last_name}"
      ticket.save
    end

    def ticket
      @ticket ||= ZENDESK_CLIENT.tickets.find(id: context.ticket_id)
    end

    def user
      id = ticket.subject.split(" ").last

      @user ||= User.find_by(id: id)
    end
  end
end
