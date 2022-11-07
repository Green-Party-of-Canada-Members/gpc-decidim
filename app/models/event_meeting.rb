# frozen_string_literal: true

class EventMeeting < Decidim::Civicrm::EventMeeting
  default_scope -> { where("extra->>'start_date' > ?", 2.years.ago) }
end
