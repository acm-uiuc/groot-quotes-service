# app.rb

require 'json'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'data_mapper'
require 'dm-migrations'
require 'dm-serializer'
require "dm_noisy_failures"
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'better_errors'
require 'dm-mysql-adapter'
require 'net/http'
require 'uri'

set :root, File.dirname(__FILE__)
set :GROOT_URL, 'http://localhost:8000/'
set :port, 9494
configure :development do
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(
        :default,
        'mysql://localhost/groot_quotes_service'
    )
    use BetterErrors::Middleware
    # you need to set the application root in order to abbreviate filenames
    # within the application:
    BetterErrors.application_root = File.expand_path('..', __FILE__)
    DataMapper.auto_upgrade!
end


configure :production do
    set :port, 9494
    DataMapper.setup(
        :default,
        'mysql://localhost/groot_quotes_service'
    )
    DataMapper.finalize
end

require_relative './models/init'
Quote.groot_path = settings.GROOT_URL
require_relative './routes/init'
require_relative './helpers/init'

DataMapper.finalize
