module ZendeskStubs
  def stub_zendesk_all_user
    users = double :users, all: []

    allow(ZENDESK_CLIENT).to receive(:users).and_return(users)
  end
end
