# frozen_string_literal: true

Rails.application.config.to_prepare do
  # block registration through Omniauth signin
  Decidim::Devise::OmniauthRegistrationsController.include(OmniauthRegistrationsControllerOverride)
  # redirect users to interest after acceptin an invitation
  Decidim::Devise::InvitationsController.include(InvitationsControllerOverride)

  # disables inviting external users if enabled
  Decidim::Meetings::Admin::InvitesController.include(InvitesControllerOverride)

  # detect custom cards for leadership campaigns
  Decidim::CardHelper.include(CardHelperOverride)
end
