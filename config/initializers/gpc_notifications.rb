# frozen_string_literal: true

Decidim::EventsManager.subscribe(/^decidim\.events\.amendments\.amendment/) do |event_name, _data|
  if ["decidim.events.amendments.amendment_rejected", "decidim.events.amendments.amendment_accepted"].include?(event_name)
    # byebug
    # data[:resource].amendable.followers
  end
end
