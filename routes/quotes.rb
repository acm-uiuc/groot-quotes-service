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

before do
    # halt(401, Errors::VERIFY_GROOT) unless Auth.verify_session(env)
end

get '/status' do
    ResponseFormat.message("OK")
end

get '/quotes' do
    ResponseFormat.data(Quote.all(order: [ :created_at.desc ], approved: params[:approved] || false))
end

get '/quotes/:quote_id' do
    status, error = Quote.validate(params, [:quote_id])
    halt(status, ResponseFormat.error(error)) if error
    
    quote = Quote.get(params[:quote_id]) || halt(404, Errors::QUOTE_NOT_FOUND)

    ResponseFormat.data(quote)
end

put '/quotes/:quote_id/vote' do
    # attempt to find vote, should not exist already
    quote_id = params[:quote_id]
    params = ResponseFormat.get_params(request.body.read)
    status, error = Quote.validate(params, [:netid])
    halt(status, ResponseFormat.error(error)) if error

    vote = Vote.first(quote_id: quote_id, netid: params[:netid])

    halt(400, Errors::DUPLICATE_VOTE) if vote

    quote = Quote.get(quote_id) || halt(404, Errors::QUOTE_NOT_FOUND)

    quote.votes.create(
        netid: params[:netid]
    )

    ResponseFormat.message("Vote cast!")
end

delete '/quote/:quote_id/vote' do
    quote_id = params[:quote_id]
    params = ResponseFormat.get_params(request.body.read)
    status, error = Quote.validate(params, [:netid])
    halt(status, ResponseFormat.error(error)) if error

    vote = Vote.first(quote_id: quote_id, netid: params[:netid]) || halt(404, Errors::VOTE_NOT_FOUND)

    halt(500) unless vote.destroy

    ResponseFormat.message("Vote destroyed!")
end

post '/quotes' do
    params = ResponseFormat.get_params(request.body.read)
    status, error = Quote.validate(params, [:author, :source, :text])
    halt status, ResponseFormat.error(error) if error

    quote = Quote.first(text: params[:text])
    return [400, Errors::DUPLICATE_QUOTE] if quote
    
    quote = Quote.create(
        author: params[:author],
        sources: params[:source],
        text: params[:text]
    )

    return ResponseFormat.message("Quote uploaded successfully.")
end

delete '/quotes/:id' do
    halt(401, Errors::VERIFY_ADMIN) unless Auth.verify_admin(env)

    quote ||= Quote.first(id: params[:id]) || halt(404)
    halt 500 unless quote.destroy
end
