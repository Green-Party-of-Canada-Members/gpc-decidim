# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module OmniauthRegistrationsControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action :ensure_user_exists, only: :create

    def call
      form_params = user_params_from_oauth_hash || params[:user]
      @form = form(OmniauthRegistrationForm).from_params(form_params)

      return if Decidim::User.exists?(email: @form.email || verified_email, organization: current_organization)

      # No registration allowed
      Rails.logger.info "WARNING: Attempt to register via OAuth: #{verified_email || form.email}"
      set_flash_message :alert, :failure, kind: @form.provider.capitalize, reason: "Only existing users are allowed to login"
    end
  end
end
