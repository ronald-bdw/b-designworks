module ZendeskStubs
  def stub_zendesk_all_user
    users = double :users, all: []

    allow(ZENDESK_CLIENT).to receive(:users).and_return(users)
  end

  def stub_zendesk_all_organizations
    organizations = double :organizations, all: []

    allow(ZENDESK_CLIENT).to receive(:organizations).and_return(organizations)
  end
end
