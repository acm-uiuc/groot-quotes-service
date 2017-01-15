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
    property :text, Text, required: true, unique: true
    property :source, String, length: 1..9 # netid
    property :author, String, required: true, length: 1...9 # netid
    property :approved, Boolean, default: false

    property :created_at, DateTime
    has n, :votes, constraint: :destroy

    def self.validate(params, attributes)
      attributes.each do |attr|
        return [400, "Missing #{attr}"] unless params[attr] && !params[attr].empty?
        # Since we cannot verify that a netid was valid, this doesn't work'
        # case attr
        # when :author
        #     return [400, "Invalid poster"] unless Auth.verify_user(params[attr])
        # when :source
        #     return [400, "Invalid source"] unless Auth.verify_user(params[attr])
        # end
      end

      [200, nil]
    end

    def set_user_voted(netid)
        @user_voted = !Vote.first(quote_id: self.id, netid: netid).nil?
    end

    def serialize
        {
            id: self.id,
            text: self.text,
            author: self.author,
            source: self.source,
            votes: self.votes.count,
            approved: self.approved,
            upvoted: @user_voted
        }
    end
end
