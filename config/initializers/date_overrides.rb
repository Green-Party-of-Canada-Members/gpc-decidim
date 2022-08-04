# frozen_string_literal: true

Rails.application.config.to_prepare do
  # allow view overrides to use custom helpers
  Decidim::CardMCell.include(ApplicationHelper)
  Decidim::DateRangeCell.include(ApplicationHelper)
end
