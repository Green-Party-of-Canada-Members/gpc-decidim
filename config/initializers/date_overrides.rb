# frozen_string_literal: true

Rails.application.config.to_prepare do
  # allow view overrides to use custom helpers
  puts "SKIPPED: Applying date overrides!"
  # Decidim::CardMCell.include(ApplicationHelper)
  # Decidim::DateRangeCell.include(ApplicationHelper)
end
