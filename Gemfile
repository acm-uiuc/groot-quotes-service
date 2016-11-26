source "https://rubygems.org"

gem 'bundler'
gem 'rake'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'foreigner'

gem 'json'
gem 'data_mapper'
gem 'dm-migrations'
gem 'dm-core'
gem 'dm-timestamps'
gem 'dm-mysql-adapter'
gem 'dm-serializer'
gem 'dm-validations'
gem 'dm-noisy-failures', '~> 0.2.3'

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'rspec'
  gem 'rack-test'
  gem 'factory_girl'
  gem 'guard-rspec'
  gem 'faker'
  gem 'shoulda'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'shotgun' # Auto-reload sinatra app on change.
  gem 'better_errors' # Show an awesome console in the browser on error.
  gem 'rest-client'
end
