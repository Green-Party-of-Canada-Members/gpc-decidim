# frozen_string_literal: true

# This cell renders the Medium (:m) assembyl card
# for an given instance of an Assembly
class ContestantMCell < Decidim::Proposals::ProposalMCell
  include ApplicationHelper

  def has_authors?
    false
  end

  def description
    attribute = model.try(:short_description) || model.try(:body) || model.description
    text = translated_attribute(attribute)

    decidim_sanitize_editor(html_truncate(text, length: 300))
  end
end
