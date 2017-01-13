# Copyright © 2016, ACM@UIUC
#
# This file is part of the Groot Project.  
# 
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.

class Quote
    include DataMapper::Resource

    property :id, Serial
    property :text, String, required: true, unique: true
    property :source, String, length: 1..9 # netid
    property :author, String, required: true, length: 1...9 # netid
    property :approvd, Boolean, default: false

    property :created_at, DateTime

    def self.validate(params, attributes)
      attributes.each do |attr|
        return [400, "Missing #{attr}"] unless params[attr] && !params[attr].empty?
        case attr
        when :text
            return [400, "Invalid quote"] unless (params[attr] =~ /^\s*$/)
        when :poster
            return [400, "Invalid poster"] unless Auth.verify_user(params[attr])
        when :source
            return [400, "Invalid source"] unless Auth.verify_user(params[attr])
        end
      end

      [200, nil]
    end

    def serialize
        {
            id: self.id,
            text: self.text,
            author: self.author,
            source: self.source
        }
    end
end
