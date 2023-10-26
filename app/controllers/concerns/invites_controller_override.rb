# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module InvitesControllerOverride
  extend ActiveSupport::Concern

  included do
    before_action :ensure_external_invites_allowed, only: :create

    def ensure_external_invites_allowed
      return unless Rails.application.secrets.dig(:gpc, :disable_external_invites)
      return if params[:meeting_registration_invite].has_key?(:existing_user) &&
                Decidim::User.exists?(id: params[:meeting_registration_invite][:user_id], organization: current_organization)

      flash[:alert] = I18n.t("gpc.external_invites_disabled")
      redirect_to meeting_registrations_invites_path(meeting)
    end
  end
end
