# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module OmniauthRegistrationsControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action :ensure_user_exists, only: :google_oauth2

    # if oauth via google is active, we don't want people to register if disabled in system (this is probably a bug in decidim)
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

    # Override this method to redirect to after invitation on new logins
    def after_sign_in_path_for(user)
      # for new logins redirect to preferences (or whatever is configured)
      if user.is_a?(Decidim::User) && user.sign_in_count == 1
        redirect = Rails.application.secrets.dig(:gpc, :redirect_after_invitation)
        return redirect if redirect.present?
      end

      if user.present? && user.blocked?
        check_user_block_status(user)
      elsif !pending_redirect?(user) && first_login_and_not_authorized?(user)
        decidim_verifications.authorizations_path
      else
        super
      end
    end
  end
end
