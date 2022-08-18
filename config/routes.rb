# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "/watch_race", to: "static#watch_race", as: :watch_race_static

  if Rails.application.secrets.dig(:gpc, :live, :watch_race).present?
    get "/", to: redirect(Rails.application.routes.url_helpers.watch_race_static_path)
  end

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
