# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", tag: "release/0.24-stable" }.freeze
DECIDIM_VERSION = { git: "https://github.com/Platoniq/decidim", tag: "fix/comparisons" }.freeze

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-decidim_awesome", "~> 0.7.0"
gem "decidim-templates", DECIDIM_VERSION
# gem "decidim-term_customizer"
gem "decidim-analytics", git: "https://github.com/digidemlab/decidim-module-analytics"
gem "decidim-calendar"
gem "decidim-direct_verifications"
gem "decidim-extra_user_fields", git: "https://github.com/PopulateTools/decidim-module-extra_user_fields"

gem "bootsnap", "~> 1.4"
# a bug in 2.8.0 is preventing precompilation
# https://github.com/rails/execjs/issues/99
gem "execjs", "~> 2.7.0"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "wicked_pdf", "~> 1.4"

gem "faker", "~> 2.14"
gem "rspec"
gem "rubocop-faker"

gem "figaro"
gem "whenever", require: false

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-figaro-yml", "~> 1.0.2", require: false
  gem "capistrano-passenger", "~> 0.2.0", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rails-console", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "passenger", "~> 6.0"
end

group :production do
  gem "daemons"
  gem "delayed_job_active_record"
end
