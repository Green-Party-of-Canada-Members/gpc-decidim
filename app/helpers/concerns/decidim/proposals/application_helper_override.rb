# frozen_string_literal: true

module Decidim
  module Proposals
    module ApplicationHelperOverride
      extend ActiveSupport::Concern

      included do
        alias_method :original_filter_sections, :filter_sections

        def filter_sections
          proposals_without_proposals_filter = Decidim::Proposals::Proposal.where(component: current_component)
                                                                           .with_availability(params[:filter].try(:[], :with_availability))
                                                                           .published
                                                                           .not_hidden
          original_filter_sections.tap do |items|
            if proposals_without_proposals_filter.only_emendations.any? && items.find { |v| v[:method] == :type }.nil?
              items.append(
                method: :type,
                collection: filter_type_values,
                label_scope: "decidim.proposals.proposals.filters",
                id: "amendment_type",
                type: :radio_buttons
              )
            end
          end
        end
      end
    end
  end
end
