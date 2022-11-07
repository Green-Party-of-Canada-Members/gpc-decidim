# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/openpoke/decidim", tag: "0.26-canada" }.freeze
# DECIDIM_VERSION = "~> 0.26.2"

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-calendar", git: "https://github.com/openpoke/decidim-module-calendar"
gem "decidim-civicrm", git: "https://github.com/openpoke/decidim-module-civicrm", branch: "improve_meetings"
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-decidim_awesome", git: "https://github.com/openpoke/decidim-module-decidim_awesome", branch: "main"
gem "decidim-direct_verifications"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", tag: "master"

gem "bootsnap", "~> 1.7"

gem "puma"

gem "wicked_pdf", "~> 2.1"

gem "deepl-rb", require: "deepl"

group :development, :test do
  gem "byebug", platform: :mri
  gem "rubocop-faker"

  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq", "<7"
  gem "sidekiq-cron"
  # Used to restart puma workers every 6h and free memory
  gem "puma_worker_killer"
end
