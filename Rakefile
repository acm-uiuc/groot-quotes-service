# Copyright © 2016, ACM@UIUC
#
# This file is part of the Groot Project.  
# 
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.
# app.rb
require './app'
require 'rake'
require 'pry'

namespace :db do

  desc "Migrate the database"
  task :migrate do
    puts "Migrating database"
    DataMapper.auto_migrate!
  end

  desc "Upgrade the database"
  task :upgrade do
    puts "Upgrading the database"
    DataMapper.auto_upgrade!
  end

  desc "Populate the database with dummy data"
  task :seed do
    DataMapper.auto_migrate!
    puts "Seeding database"
    require './scripts/seed.rb'
  end
end


namespace :generate do

  desc "Add new spec file"
  task :spec do
    unless ENV.has_key?('NAME')
      raise "Must specify spec file name, e.g., rake generate:spec NAME=craftsman_profile"
    end

    spec_path = "spec/" + ENV['NAME'].downcase + "_spec.rb"

    if File.exist?(spec_path)
      raise "ERROR: Spec file '#{spec_path}' already exists."
    end

    puts "Creating #{spec_path}"
    File.open(spec_path, 'w+') do |f|
      f.write("require 'spec_helper'")
    end
  end

end

desc 'Start Pry with application environment loaded'
task :pry  do
    exec "pry -r./init.rb"
end
