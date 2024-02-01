# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module AmendableAcceptOverride
  extend ActiveSupport::Concern

  included do
    private

    def notify_amendable_and_emendation_authors_and_followers
      affected_users = emendation.authors + @amendable.notifiable_identities
      followers = emendation.followers + affected_users
      # do not send the standard notification to the amnendable followers
      Decidim::EventsManager.publish(
        event: "decidim.events.amendments.amendment_accepted",
        event_class: Decidim::Amendable::AmendmentAcceptedEvent,
        resource: emendation,
        affected_users: affected_users.uniq,
        followers: followers.uniq
      )

      followers = @amendable.followers - followers
      # send a custom notification accepted/rejected to followers of the original proposal
      # not the authors or follower of the amendment
      Decidim::EventsManager.publish(
        event: "decidim.events.ready_to_amend.amendment_accepted",
        event_class: Decidim::Amendable::ReadyAcceptedEvent,
        resource: @amendable,
        affected_users: [],
        followers: followers.uniq
      )
    end
  end
end
