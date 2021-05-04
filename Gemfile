# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.23.3"
# gem "decidim-consultations", "0.23.1"
# gem "decidim-initiatives", "0.23.1"
# gem "decidim-templates", "0.23.1"
gem "decidim-decidim_awesome", "~> 0.7.0"
# gem "decidim-term_customizer"
gem "decidim-calendar"
gem "decidim-direct_verifications"
gem "decidim-extra_user_fields", git: "https://github.com/PopulateTools/decidim-module-extra_user_fields"
gem "decidim-analytics", git: "https://github.com/digidemlab/decidim-module-analytics"

gem "bootsnap", "~> 1.3"

gem "puma", ">= 4.3.5"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"

gem "wicked_pdf", "~> 1.4"

gem "figaro"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.23.3"
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
  gem 'delayed_job_active_record'
  gem "daemons"
end
