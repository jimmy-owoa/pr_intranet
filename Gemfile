source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.3"
# Use sqlite3 as the database for Active Record
gem "mysql2", ">= 0.4.4", "< 0.6.0"
# Use Puma as the app server
gem "puma", "~> 3.11"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password

#login user
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "simple_command"
#csv reader duh
gem "csvreader"

gem "simple_form"

# authorization system
gem "devise"
# oauth2 azure ad
gem "omniauth"
gem "omniauth-azure-oauth2"

# this is for the console using 'ap'
gem "awesome_print"
#Nested forms with dynamic fields
gem "cocoon"
#Vuejs
gem "rack-cors", require: "rack/cors"
#Breadcrumbs
gem "breadcrumbs_on_rails"
gem "jquery-rails"
# mini_magick works with active storage for resize images
gem "mini_magick"
gem "image_processing", "~> 1.2"
# Design and js/css utilities
gem "bootstrap", "~> 4.1.3"
gem "font-awesome-sass", "~> 5.3.1"
gem "toastr-rails"
gem "tinymce-rails"
# Internationalizatin for tinymce
gem "tinymce-rails-langs"
# It's for the datetime-picker of Tempus Dominus Bootstrap 4
gem "bootstrap4-datetime-picker-rails"
gem "momentjs-rails"
# select2 for forms
gem "select2-rails"
#authorization system
gem "pundit"
#role system
gem "rolify"
#searching for elasticsearch
gem "searchkick"
#paginate
gem "will_paginate-bootstrap4"
#Soft delete
gem "paranoia", "~> 2.2"
#calendar
gem "simple_calendar", "~> 2.0"
#hierarchical user
gem "awesome_nested_set"
#scheduled jobs
gem "whenever", require: false
# active storage validations
gem "active_storage_validations"
# paginate for API
gem "kaminari"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Cache dalli
gem "dalli"
# xlsx gem creator
gem "rubyzip", ">= 1.2.1"
gem "axlsx", git: "https://github.com/randym/axlsx.git", ref: "c8ac844"
gem "axlsx_rails"
# Read excel files
gem "roo", "~> 2.8.0"
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
#test carousel
gem "owlcarousel-rails"
gem "best_in_place", "~> 3.0.1"
#works
# gem 'sidekiq'
#code css
gem "jquery-minicolors-rails"
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
gem "data-confirm-modal"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
#clipboard
gem "clipboard-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-rails"
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "selenium-webdriver"
end

group :development do
  # Use Capistrano for deployment
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano-passenger", "~> 0.2.0"
  #debugear yml
  # gem 'i18n-debug'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
