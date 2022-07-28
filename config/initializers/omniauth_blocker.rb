# frozen_string_literal: true

Rails.application.config.to_prepare do
	Decidim::Devise::OmniauthRegistrationsController.include(OmniauthRegistrationsControllerOverride)
end