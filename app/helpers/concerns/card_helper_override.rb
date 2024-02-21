# frozen_string_literal: true

module CardHelperOverride
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    def card_for(model, options = {})
      if contestants_component?(model.try(:component))
        cell "contestant_m", model
      elsif leadership_assembly?(model)
        cell "leadership_m", model
      elsif model.is_a?(Decidim::Meetings::Meeting) && leadership_assembly?(model.try(:participatory_space))
        cell "leadership_meeting_m", model
      else
        cell "decidim/card", model, options
      end
    end
  end
end
