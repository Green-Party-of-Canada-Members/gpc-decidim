# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module InvitationsControllerOverride
  extend ActiveSupport::Concern

  included do
    def after_accept_path_for(resource)
      redirect = Rails.application.secrets.dig(:gpc, :redirect_after_invitation)
      redirect.presence || invite_redirect_path || after_sign_in_path_for(resource)
    end
  end
end
