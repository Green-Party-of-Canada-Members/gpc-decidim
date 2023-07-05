# frozen_string_literal: true

# A command with all the business logic to create a user from omniauth
module HighlightedProposalsForComponentCellOverride
  extend ActiveSupport::Concern

  included do
    def proposals_to_render
      @proposals_to_render ||= proposals.includes([:amendable, :category, :component, :scope]).limit(proposal_limit)
    end

    def proposal_limit
      race = Rails.application.secrets.dig(:gpc, :processes, :leadership_race)
      return 12 if model&.participatory_space&.slug == race

      Decidim::Proposals.config.participatory_space_highlighted_proposals_limit
    end
  end
end
