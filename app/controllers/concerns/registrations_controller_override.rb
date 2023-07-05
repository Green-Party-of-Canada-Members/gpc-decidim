# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module RegistrationsControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action :redirect_sign_up

    def redirect_sign_up
      redirect_sign_up = Rails.application.secrets.dig(:gpc, :redirect_sign_up)
      return if redirect_sign_up.blank?

      redirect_to redirect_sign_up.gsub("%{locale}", params[:locale].presence || Decidim.default_locale)
    end
  end
end
