# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "/watch_race", to: "static#watch_race", as: :watch_race_static

  get "/", to: redirect(Rails.application.routes.url_helpers.watch_race_static_path) if Rails.application.secrets.dig(:gpc, :live, :watch_race).present?

  events = Decidim::Assembly.published.find_by(slug: Rails.application.secrets.dig(:gpc, :assemblies, :leadership_events))
  if events.present?
    first = events.components.published.first
    get "/assemblies/#{events.slug}", to: redirect("/assemblies/#{events.slug}/f/#{first.id}") if first.present?
  end

  mount Decidim::Core::Engine => "/"
end
