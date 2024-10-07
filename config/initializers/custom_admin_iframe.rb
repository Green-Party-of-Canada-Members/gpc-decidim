# frozen_string_literal: true

Decidim.menu :admin_menu do |menu|
  menu.add_item :custom_iframe,
                ENV.fetch("ADMIN_IFRAME_TITLE", "Plausible Stats"),
                Rails.application.routes.url_helpers.admin_iframe_index_path,
                icon_name: "bar-chart-2-line",
                position: 10,
                if: ENV.fetch("ADMIN_IFRAME_URL", nil).present?
end
