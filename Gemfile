# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # generate favicon
  gem 'rails_real_favicon'
  # debug
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  # n+1
  gem 'bullet'

  # security check
  gem 'brakeman'

  gem 'aws-sdk'
end

group :production do
  # new relic
  gem 'newrelic_rpm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# for Bootstrap
gem 'bootstrap', '~> 4.1.0'
gem 'jquery-rails'

# Use SCSS for stylesheets and bootstrap
gem 'sass-rails'

# For normalize string
gem 'moji'

# For import record
gem 'activerecord-import'

# For search
gem 'ransack'

# font awesome
gem 'font-awesome-sass'

# active admin
gem 'activeadmin'
gem 'devise'
gem 'active_admin_import', '~> 3.1'

# For decorator
gem 'draper'

# For output ics
gem 'icalendar'

# For similar string matching
gem 'levenshtein'

# geocoder
gem 'geocoder'
gem 'httpclient'

# env
gem 'dotenv-rails'

# for google-analysis
gem 'google-analytics-rails'

# rollbar
gem 'rollbar'

# for PWA
gem 'serviceworker-rails'

# screenshot
gem 'selenium-webdriver'
gem 'mini_magick'
