# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module CreateOmniauthRegistrationOverride
  extend ActiveSupport::Concern

  included do
    def create_or_find_user
      generated_password = SecureRandom.hex

      @user = User.find_or_initialize_by(
        email: verified_email,
        organization: organization
      )

      if @user.persisted?
        # If user has left the account unconfirmed and later on decides to sign
        # in with omniauth with an already verified account, the account needs
        # to be marked confirmed.
        @user.skip_confirmation! if !@user.confirmed? && @user.email == verified_email
      else
        # No registration allowed
        Rails.logger.info "WARNING: Attempt to register via OAuth: #{verified_email || form.email}"
        raise ActiveRecord::RecordInvalid, "Sorry, registration via OAuth is disabled. You need to be registered in the platform first."
        # @user.email = (verified_email || form.email)
        # @user.name = form.name
        # @user.nickname = form.normalized_nickname
        # @user.newsletter_notifications_at = nil
        # @user.password = generated_password
        # @user.password_confirmation = generated_password
        # if form.avatar_url.present?
        #   url = URI.parse(form.avatar_url)
        #   filename = File.basename(url.path)
        #   file = URI.open(url)
        #   @user.avatar.attach(io: file, filename: filename)
        # end
        # @user.skip_confirmation! if verified_email
      end

      @user.tos_agreement = "1"
      @user.save!
    end
  end
end
