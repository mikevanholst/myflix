source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'figaro' # sets environment variables
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem 'redis'
gem 'unicorn'
gem 'foreman'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'draper'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener' # opens emails in the browser
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :test, :development do
  gem 'pry'
  gem 'pry-nav'
  gem "rspec-rails"
end

group :test do
  gem 'launchy'  # allows save_and_open_page for capybara
  gem 'capybara', '2.1.0'
  gem 'shoulda-matchers' 
  gem 'capybara-email', '2.1.2'
  gem 'vcr'
  gem 'webmock', '1.15.0'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'capybara-webkit'
end