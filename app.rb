# Copyright © 2017, ACM@UIUC
#
# This file is part of the Groot Project.
#
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.
# app.rb

require 'json'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/cross_origin'
require 'data_mapper'
require 'dm-migrations'
require 'dm-serializer'
require 'dm_noisy_failures'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'better_errors'
require 'dm-mysql-adapter'
require 'net/http'
require 'uri'
require 'oga'

require_relative './models/init'
require_relative './routes/init'
require_relative './helpers/init'

register Sinatra::CrossOrigin

configure do
  enable :cross_origin
end

set :root, File.expand_path('..', __FILE__)
set :port, 9494
set :bind, '0.0.0.0'

configure :development, :production do
  db = Config.load_config('database')
  DataMapper.setup(
    :default,
    'mysql://' + db['user'] + ':' + db['password'] + '@' + db['hostname'] + '/' + db['name']
  )
end

configure :development do
  enable :unsecure
  register Sinatra::Reloader

  DataMapper::Logger.new($stdout, :debug)
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('..', __FILE__)
  DataMapper.auto_upgrade!
end

configure :test do
  db = Config.load_config('test_database')
  DataMapper.setup(:default, 'mysql://' + db['user'] + ':' + db['password'] + '@' + db['hostname'] + '/' + db['name'])
end

configure :production do
  disable :unsecure
end

DataMapper.finalize
