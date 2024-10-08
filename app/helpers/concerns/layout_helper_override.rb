# frozen_string_literal: true

module LayoutHelperOverride
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    def extended_navigation_bar(items, max_items: Rails.application.secrets.gpc[:submenu_max_items] || 5)
      return unless items.any?

      extra_items = items.slice((max_items + 1)..-1) || []
      active_item = items.find { |item| item[:active] }

      controller.view_context.render partial: "decidim/shared/extended_navigation_bar", locals: {
        items:,
        extra_items:,
        active_item:,
        max_items:
      }
    end
  end
end
