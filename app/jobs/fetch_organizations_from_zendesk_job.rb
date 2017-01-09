class FetchOrganizationsFromZendeskJob < ActiveJob::Base
  queue_as :default

  def perform
    organizations_ids = []

    ZENDESK_CLIENT.organizations.all do |organization|
      organizations_ids << organization.id
      create_or_update_org(organization)
    end

    delete_unnecessary_orgs(organizations_ids.compact)
  end

  private

  def create_or_update_org(zendesk_org)
    organization = Provider.find_or_initialize_by(zendesk_id: zendesk_org.id)
    organization.name = zendesk_org.name
    organization.save
  end

  def delete_unnecessary_orgs(zendesk_ids)
    return if zendesk_ids.blank?
    unused_orgs = Provider.where.not(zendesk_id: zendesk_ids)
    remove_users_org(unused_orgs.pluck(:id)) if unused_orgs.present?
    unused_orgs.map(&:destroy)
  end

  def remove_users_org(orgs_ids)
    users = User.by_provider(orgs_ids)
    users&.update_all(provider_id: nil)
  end
end
