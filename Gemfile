# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.28-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-calendar", github: "decidim-ice/decidim-module-calendar", branch: "main"
gem "decidim-civicrm", github: "openpoke/decidim-module-civicrm", branch: "main"
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "main"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "main"

gem "bootsnap", "~> 1.7"
gem "deepl-rb", require: "deepl"
gem "deface"
gem "puma"
gem "wicked_pdf", "~> 2.1"
gem "health_check"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION

  gem "brakeman", "~> 5.4"
  gem "net-imap", "~> 0.2.3"
  gem "net-pop", "~> 0.1.1"
  gem "net-smtp", "~> 0.3.1"
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
end
