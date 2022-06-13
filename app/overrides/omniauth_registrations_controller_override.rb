# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module OmniauthRegistrationsControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action :ensure_user_exists, only: :google_oauth2

    def ensure_user_exists
      form_params = user_params_from_oauth_hash || params[:user]
      @form = form(Decidim::OmniauthRegistrationForm).from_params(form_params)
      email = @form.email || verified_email

      return if email.present? && Decidim::User.exists?(email: email, organization: current_organization)

      # No registration allowed
      Rails.logger.info "WARNING: Attempt to register via OAuth: #{email}"
      flash[:alert] = I18n.t("email_not_registered", email: email)
      redirect_to decidim.root_path
    end
  end
end
