source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# gem 'nokogiri', '1.10.8'
# adminlte
ruby '2.7.5'

gem 'adminlte-rails'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# QR generation
gem 'rqrcode', '~> 1.1', '>= 1.1.2'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
# Select2
gem 'select2-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'autoprefixer-rails', '~> 8.6.5'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', require: 'bcrypt'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'font-awesome-sass', '~> 5.8.1'
gem 'pg', '1.2.3'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Jquery UI
gem 'active_record_union'
gem 'jquery-ui-rails'
gem 'rack-mini-profiler'
gem 'rake', '~> 12.3.3'
gem 'will_paginate', '~> 3.3'
gem 'writeexcel'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'railroady'
  gem 'rails-erd'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'