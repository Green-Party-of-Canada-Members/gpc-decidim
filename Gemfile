# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.27-canada" }.freeze
# DECIDIM_VERSION = "~> 0.27.4"

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-calendar", github: "decidim-ice/decidim-module-calendar", branch: "release/0.27-stable"
gem "decidim-civicrm", github: "openpoke/decidim-module-civicrm"
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome"
gem "decidim-direct_verifications", github: "Platoniq/decidim-verifications-direct_verifications"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.27-stable"

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
