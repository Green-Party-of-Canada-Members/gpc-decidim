# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/openpoke/decidim", tag: "diff-booster" }.freeze
# DECIDIM_VERSION = "~> 0.26.2"

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION
# gem "decidim-term_customizer"
gem "decidim-analytics", git: "https://github.com/digidemlab/decidim-module-analytics"
gem "decidim-calendar", git: "https://github.com/openpoke/decidim-module-calendar", tag: "update-26"
gem "decidim-decidim_awesome"
gem "decidim-direct_verifications"

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

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-figaro-yml", "~> 1.0.2", require: false
  gem "capistrano-passenger", "~> 0.2.0", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rails-console", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
end

group :production do
  gem "figaro"
  gem "sidekiq"
  gem "sidekiq-cron"
end
