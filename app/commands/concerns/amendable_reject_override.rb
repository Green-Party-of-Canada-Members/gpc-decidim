# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module AmendableRejectOverride
  extend ActiveSupport::Concern

  included do
    alias_method :original_notify_emendation_authors_and_followers, :notify_emendation_authors_and_followers

    private

    def notify_emendation_authors_and_followers
      return original_notify_emendation_authors_and_followers unless @amendable.component.settings.limit_pending_amendments

      # do not send the standard notification to the amnendable followers
      affected_users = @emendation.authors + @amendable.notifiable_identities
      followers = @emendation.followers + affected_users

      Decidim::EventsManager.publish(
        event: "decidim.events.amendments.amendment_rejected",
        event_class: Decidim::Amendable::AmendmentRejectedEvent,
        resource: @emendation,
        affected_users: affected_users.uniq,
        followers: followers.uniq
      )

      followers = @amendable.followers - followers
      # send a custom notification accepted/rejected to followers of the original proposal
      # not the authors or follower of the amendment
      Decidim::EventsManager.publish(
        event: "decidim.events.ready_to_amend.amendment_rejected",
        event_class: Decidim::Amendable::ReadyRejectedEvent,
        resource: @amendable,
        affected_users: [],
        followers: followers.uniq
      )
    end
  end
end
