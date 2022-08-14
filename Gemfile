# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/openpoke/decidim", tag: "diff-booster" }.freeze
# DECIDIM_VERSION = "~> 0.26.2"

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-calendar", git: "https://github.com/openpoke/decidim-module-calendar", tag: "update-26"
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-decidim_awesome"
gem "decidim-direct_verifications"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", tag: "master"

gem "bootsnap", "~> 1.7"

gem "puma"
gem "uglifier"

gem "deepl-rb", require: "deepl"

group :development, :test do
  gem "byebug", platform: :mri
  gem "rubocop-faker"

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 2.18"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"

  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-rails-console", require: false
  gem "capistrano-rbenv", require: false
  gem "capistrano-sidekiq", require: false
end

group :production do
  gem "figaro"
  gem "sidekiq"
  gem "sidekiq-cron"
end
