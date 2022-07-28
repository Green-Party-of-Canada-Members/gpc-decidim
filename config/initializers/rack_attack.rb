# frozen_string_literal: true

if Rails.env.production?
    # skip rails active storage routes
  Rack::Attack.safelist("bypass active storage") do |request|
    request.path.start_with?("/rails/active_storage")
  end

  # skip logged users
  Rack::Attack.safelist("bypass authenticated users") do |request|
    request.env.dig("rack.session", "warden.user.user.key").present?
  end

  # Provided that trusted users use an HTTP request param named skip_rack_attack
  # with this you can perform apache benchmark test like this:
  # ab -n 2000 -c 20 'https://decidim.url/?skip_rack_attack=some-secret'
  Rack::Attack.safelist("bypass with secret param") do |request|
    # Requests are allowed if the return value is truthy
    skip = Rails.application.secrets.rack_attack_skip || "let-me-hack"
    request.params["skip_rack_attack"] == skip
  end
end
