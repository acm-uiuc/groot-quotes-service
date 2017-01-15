# Copyright © 2016, ACM@UIUC
#
# This file is part of the Groot Project.  
# 
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.
# app.rb
# encoding: UTF-8
require_relative '../models/quote'

def set_user_voted(quotes)
    quotes.map do |quote|
        quote.set_user_voted(@netid)
    end

    quotes
end

before do
    halt(401, Errors::VERIFY_GROOT) unless Auth.verify_session(env)
    @netid = env["HTTP_NETID"]
    halt(400, ResponseFormat.error("No netid provided")) unless @netid
end

get '/status' do
    ResponseFormat.message("OK")
end

get '/quotes' do
    quotes = Quote.all(order: [ :approved.asc, :created_at.desc ])
    ResponseFormat.data(set_user_voted(quotes))
end

get '/quotes/:id' do
    status, error = Quote.validate(params, [:id])
    halt(status, ResponseFormat.error(error)) if error
    
    quote = Quote.get(params[:id]) || halt(404, Errors::QUOTE_NOT_FOUND)
    quote.set_user_voted(@netid)
    ResponseFormat.data(quote)
end

post '/quotes/:id/vote' do
    id = params[:id]
    params = ResponseFormat.get_params(request.body.read)
    
    vote = Vote.first(id: id, netid: @netid)
    halt(400, Errors::DUPLICATE_VOTE) if vote

    quote = Quote.get(id) || halt(404, Errors::QUOTE_NOT_FOUND)
    quote.votes.create(
        netid: @netid
    )

    ResponseFormat.message("Vote cast!")
end

delete '/quotes/:id/vote' do
    vote = Vote.first(quote_id: params[:id], netid: @netid) || halt(404, Errors::VOTE_NOT_FOUND)
    halt 500 unless vote.destroy

    ResponseFormat.message("Vote destroyed!")
end

post '/quotes' do
    params = ResponseFormat.get_params(request.body.read)
    
    status, error = Quote.validate(params, [:author, :source, :text])
    halt status, ResponseFormat.error(error) if error

    quote = Quote.first(text: params[:text])
    halt 400, Errors::DUPLICATE_QUOTE if quote

    quote = Quote.create(
        author: params[:author],
        source: params[:source],
        text: params[:text]  
    )

    ResponseFormat.message("Quote uploaded successfully.")
end

put '/quotes/:id/approve' do
    halt(401, Errors::VERIFY_ADMIN) unless Auth.verify_admin(env)
    quote = Quote.get(params[:id]) || halt(404, Errors::QUOTE_NOT_FOUND)
    
    halt 400, Errors::QUOTE_APPROVED if quote.approved
    quote.update(approved: true) || halt(500)

    quotes = Quote.all(order: [ :approved.asc, :created_at.desc ])
    ResponseFormat.data(set_user_voted(quotes))
end

delete '/quotes/:id' do
    halt(401, Errors::VERIFY_ADMIN) unless Auth.verify_admin(env)

    quote = Quote.get(params[:id]) || halt(404, Errors::QUOTE_NOT_FOUND)
    halt 500 unless quote.destroy

    quotes = Quote.all(order: [ :approved.asc, :created_at.desc ])
    ResponseFormat.data(set_user_voted(quotes))
end
