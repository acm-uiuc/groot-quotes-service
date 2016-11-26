# encoding: UTF-8
require_relative '../models/quote'

get '/' do
    "This is the groot quotes service"
end

get '/quotes' do
    format_response(Quote.all(order: [ :date.desc ]), request.accept)
end

get '/quotes/:id' do
    quote ||= Quote.first(id: params[:id]) || halt(404)
    puts quote.inspect
    format_response(quote, request.accept)
end

post '/quotes' do
    payload = JSON.parse(request.body.read)
    return [400, "Missing poster"] unless payload["poster"]
    return [400, "Missing source"] unless payload["sources"]
    return [400, "Missing text"] unless payload["text"]
    valid = Quote.is_valid_quote?(payload["poster"], payload["text"])
    puts valid
    quote = nil
    if valid == 0
        p payload["sources"]
        quote = (Quote.create(
                poster: payload["poster"],
                sources: payload["sources"],
                text: payload["text"],
                date: Time.now.getutc
            ))
        puts quote.inspect
    end
    status = valid == 0 ? 201 : 403
    puts status
    return [status,format_response(quote, request.accept)]
end

put '/quotes/:id' do
    payload = JSON.parse(request.body.read)
    return [400, "Missing poster"] unless payload["poster"]
    return [400, "Missing sources"] unless payload["sources"]
    return [400, "Missing text"] unless payload["text"]
    valid = Quote.is_valid_quote?(payload["poster"], payload["text"])
    if valid != 0
        status = 403
        return
    end
    quote ||= Quote.first(id: params[:id]) || halt(404)
    halt 500 unless quote.update(
        poster: payload["poster"],
        sources: payload["sources"],
        text: payload["text"],
    )
    return [status,format_response(quote, request.accept)]
end

delete '/quotes/:id' do
    quote ||= Quote.first(id: params[:id]) || halt(404)
    halt 500 unless quote.destroy
end
