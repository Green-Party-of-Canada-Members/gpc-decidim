# frozen_string_literal: true

Rails.application.config.to_prepare do
  # block registration through Omniauth signin
  Decidim::Devise::OmniauthRegistrationsController.include(OmniauthRegistrationsControllerOverride)

  # detect custom cards for leadership campaigns
  Decidim::CardHelper.include(CardHelperOverride)
end
