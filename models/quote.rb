# Copyright © 2017, ACM@UIUC
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
  property :source, String # netid
  property :author, String, required: true # netid
  property :approved, Boolean, default: false
  property :created_at, DateTime
  has n, :votes, constraint: :destroy

  def self.validate(params, attributes)
    attributes.each do |attr|
      return [400, "Missing #{attr}"] unless params[attr] && !params[attr].empty?
      # TODO: when we can verify a netid was valid, uncomment this code
      # case attr
      # when :author
      #   return [400, 'Invalid poster'] unless Auth.verify_user(params[attr])
      # when :source
      #   return [400, 'Invalid source'] unless Auth.verify_user(params[attr])
      # end
    end

    [200, nil]
  end

  def update_user_voted(netid)
    @user_voted = !Vote.first(quote_id: id, netid: netid).nil?
  end

  def serialize
    {
      id: id,
      text: text,
      author: author,
      source: source,
      votes: votes.count,
      approved: approved,
      created_at: created_at.strftime('%x %r'),
      upvoted: @user_voted
    }
  end
end
