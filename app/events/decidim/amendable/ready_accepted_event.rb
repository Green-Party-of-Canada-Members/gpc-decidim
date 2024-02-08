# frozen-string_literal: true

module Decidim::Amendable
  class ReadyAcceptedEvent < Decidim::Amendable::AmendmentBaseEvent
    def amendable_resource
      @amendable_resource ||= resource
    end

    def emendation_resource
      @emendation_resource ||= resource
    end

    def event_has_roles?
      true
    end
  end
end
