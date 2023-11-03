# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "openpoke/decidim", tag: "0.26-canada" }.freeze
# DECIDIM_VERSION = "~> 0.26.2"

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-calendar", github: "decidim-ice/decidim-module-calendar", tag: "54b486c84f1c65b69b0aab66160c32bafc4fe376"
gem "decidim-civicrm", github: "openpoke/decidim-module-civicrm", branch: "release/0.26-stable"
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "develop"
gem "decidim-direct_verifications"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

gem "bootsnap", "~> 1.7"

gem "deface"

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
  gem "sidekiq"
  gem "sidekiq-cron"
  # # Used to restart puma workers every 6h and free memory
  # gem "puma_worker_killer"
end
