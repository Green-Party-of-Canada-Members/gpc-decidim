# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module CreateOmniauthRegistrationOverride
  extend ActiveSupport::Concern

  included do
    alias_method :original_call, :call

    def call
      user = Decidim::User.find_by(
        email: verified_email,
        organization: organization
      )

      return original_call if user.present?

      # No registration allowed
      Rails.logger.info "WARNING: Attempt to register via OAuth: #{verified_email || form.email}"
      broadcast :invalid
    end
  end
end
