# Copyright © 2016, ACM@UIUC
#
# This file is part of the Groot Project.  
# 
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.
# app.rb

class Vote
    include DataMapper::Resource

    property :id, Serial
    property :netid, String, required: true
    belongs_to :quote, key: true
end