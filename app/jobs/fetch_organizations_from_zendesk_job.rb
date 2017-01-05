class FetchOrganizationsFromZendeskJob < ActiveJob::Base
  queue_as :high_priority

  WHITE_LIST = %w(HBF BDW).freeze

  def perform
    organizations_ids = []

    ZENDESK_CLIENT.organizations.all do |organization|
      if zendesk_org_valid?(organization)
        organizations_ids << organization.id
        create_or_update_org(organization)
      end
    end

    delete_unnecessary_orgs(organizations_ids.compact)
  end

  private

  def create_or_update_org(zendesk_org)
    organization = Provider.find_or_initialize_by(zendesk_id: zendesk_org.id)
    organization.name = zendesk_org.name
    organization.save
  end

  def zendesk_org_valid?(zendesk_org)
    WHITE_LIST.include?(zendesk_org.name)
  end

  def delete_unnecessary_orgs(zendesk_ids)
    Provider.where.not(zendesk_id: zendesk_ids).map(&:destroy) if zendesk_ids.present?
  end
end
