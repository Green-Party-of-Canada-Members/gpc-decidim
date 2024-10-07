# frozen_string_literal: true

# This cell renders the Medium (:m) assembyl card
# for an given instance of an Assembly
# class LeadershipMCell < Decidim::Assemblies::AssemblyMCell
#   include ApplicationHelper

#   def description
#     attribute = model.try(:short_description) || model.try(:body) || model.description
#     text = translated_attribute(attribute)

#     decidim_sanitize_editor(html_truncate(text, length: 300))
#   end
# end
