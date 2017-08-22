require 'faker'
require_relative '../models/init'
require_relative '../helpers/init'

100.times do
  Quote.create(
    text: Faker::Lorem.unique.sentence(1),
    author: Faker::Internet.user_name(6..7),
    source: Faker::Internet.user_name(6..7),
    approved: [true, false].sample
  )
end

1000.times do
  Quote.get(rand(1..100)).votes.create(
    netid: Faker::Internet.user_name(6..7)
  )
end
