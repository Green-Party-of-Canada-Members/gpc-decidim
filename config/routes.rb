# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :admin do
    resources :iframe, only: [:index]
  end

  watch_race = Rails.application.secrets.dig(:gpc, :watch_race_iframe)
  redirect_homepage = Rails.application.secrets.dig(:gpc, :redirect_homepage)

  get "/watch_race", to: "static#watch_race", as: :watch_race_static if watch_race.present?

  get "/", to: redirect(redirect_homepage) if redirect_homepage.present?

  # ignore failure due non connections to database (can happen through precompilation process)
  # rubocop:disable Lint/SuppressedException:
  begin
    events = Decidim::Assembly.published.find_by(slug: Rails.application.secrets.dig(:gpc, :assemblies, :leadership_events))
    if events.present?
      first = events.components.published.first
      get "/assemblies/#{events.slug}", to: redirect("/assemblies/#{events.slug}/f/#{first.id}") if first.present?
    end
  rescue StandardError
  end
  # rubocop:enable Lint/SuppressedException:

  mount Decidim::Core::Engine => "/"
end
