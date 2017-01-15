require_relative '../../app'
require 'spec_helper'

RSpec.describe Sinatra::Application do
  before do
    expect(Auth).to receive(:verify_session).and_return(true)
  end
  
  let(:user_netid) { "ssapra2" }
  let(:quote) { "quote" }
  let(:author) { "netid1" }
  let(:source) { "netid2" }

  describe 'GET /quotes' do
    context 'when there are no quotes' do
      it 'should not return an error' do
        get "/quotes", {}, {"HTTP_NETID" => user_netid }

        expect(last_response).to be_ok
      end
    end

    context 'when there are quotes' do
      let!(:q) {
        Quote.create(
          text: quote,
          author: author,
          source: source,
          approved: false
        )
      }

      it 'should return the quote' do
        get "/quotes", {}, {"HTTP_NETID" => user_netid }
        
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response.body)
        expect(json_response["data"].count).to eq 1
        expect(json_response["data"][0]["text"]).to eq quote
        expect(json_response["data"][0]["upvoted"]).to be false
        expect(json_response["data"][0]["votes"]).to eq 0
      end

      context 'and someone upvoted the quote' do
        it 'should increment the votes to 1' do
          q.votes.create(
            netid: source
          )

          get "/quotes", {}, {"HTTP_NETID" => user_netid }
        
          expect(last_response).to be_ok
          json_response = JSON.parse(last_response.body)
          expect(json_response["data"].count).to eq 1
          expect(json_response["data"][0]["text"]).to eq quote
          expect(json_response["data"][0]["upvoted"]).to be false
          expect(json_response["data"][0]["votes"]).to eq 1
        end
      end
      
      context 'and the user upvoted the quote' do
        it 'should set the upvoted to true' do
          q.votes.create(
            netid: user_netid
          )

          get "/quotes", {}, {"HTTP_NETID" => user_netid }
        
          expect(last_response).to be_ok
          json_response = JSON.parse(last_response.body)
          expect(json_response["data"].count).to eq 1
          expect(json_response["data"][0]["text"]).to eq quote
          expect(json_response["data"][0]["upvoted"]).to eq true
          expect(json_response["data"][0]["votes"]).to eq 1
        end
      end
    end
  end

  describe 'GET /quotes/:id' do
    let(:quote) { "quote" }
    let(:author) { "netid1" }
    let(:source) { "netid2" }
    let!(:q) {
      Quote.create(
        text: quote,
        author: author,
        source: source,
        approved: false
      )
    }

    it 'should return an error if no quote exists' do
      get "/quotes/55", {}, {"HTTP_NETID" => user_netid}

      expect(last_response).not_to be_ok
    end

    it 'should return the quote by id' do
      get "/quotes/#{q.id}", {}, {"HTTP_NETID" => user_netid}

      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response["data"]["author"]).to eq author
    end
  end

  describe 'POST /quotes/:id/vote' do
    context 'when the quote does not exist' do
      it 'should return an error' do
        post '/quotes/55/vote', {}, {"HTTP_NETID" => "ssapra2"}

        expect(last_response).not_to be_ok
      end
    end

    context 'when the quote exists' do
      let!(:q) {
        Quote.create(
          text: quote,
          author: author,
          source: source,
          approved: false
        )
      }

      it 'should cast the vote' do
        post "/quotes/#{q.id}/vote", {}, {"HTTP_NETID" => user_netid}

        expect(last_response).to be_ok
      end
    end
  end

  describe 'DELETE /quotes/:id/vote' do
    context 'when the quote does not exist' do
      it 'should return an error that the quote is not found' do
        delete '/quotes/55/vote', {}, {"HTTP_NETID" => user_netid}

        expect(last_response).not_to be_ok
      end
    end

    context 'when the quote exists' do
      let!(:q) {
        Quote.create(
          text: quote,
          author: author,
          source: source,
          approved: false
        )
      }

      it 'should delete the vote' do
        q.votes.create(
          netid: user_netid
        )

        delete "/quotes/#{q.id}/vote", {}, {"HTTP_NETID" => user_netid}
        expect(last_response).to be_ok
      end
    end
  end

  describe 'POST /quotes' do

  end

  describe 'PUT /quotes/:id/approve' do
    before do
      allow(Auth).to receive(:verify_admin).and_return(true)
    end

    context 'when the quote is not found' do
      it 'should return an error' do
        put '/quotes/55/approve', {}, {"HTTP_NETID" => user_netid}

        expect(last_response).not_to be_ok
      end
    end

    context 'when the quote exists' do
      let!(:q) {
        Quote.create(
          text: quote,
          author: author,
          source: source,
          approved: false
        )
      }

      it 'should not approve a quote already approved' do
        q.update(approved: true)

        put "/quotes/#{q.id}/approve", {}, {"HTTP_NETID" => user_netid}

        expect(last_response).not_to be_ok
      end

      it 'should approve the quote and return others' do
        expect(q.approved).to be false
        put "/quotes/#{q.id}/approve", {}, {"HTTP_NETID" => user_netid}
        expect(last_response).to be_ok
        expect(Quote.last.approved).to be true
      end
    end
  end

  describe 'DELETE /quotes/:id' do
    before do
      allow(Auth).to receive(:verify_admin).and_return(true)
    end

    context 'when the quote is not found' do
      it 'should return an error' do
        delete '/quotes/55', {}, {"HTTP_NETID" => user_netid}

        expect(last_response).not_to be_ok
      end
    end

    context 'when the quote exists' do
      let!(:q) {
        Quote.create(
          text: quote,
          author: author,
          source: source,
          approved: false
        )
      }

      it 'should delete the quote and return others' do
        delete "/quotes/#{q.id}", {}, {"HTTP_NETID" => user_netid}

        expect(last_response).to be_ok
        expect(Quote.last).to be_nil
      end
    end
  end
end