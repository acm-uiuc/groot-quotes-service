require 'faker'
require_relative '../models/init'
require_relative '../helpers/init'

100.times do
  Quote.create(
    text: Faker::Lorem.sentence(rand(2..10)).chomp('.'),
    netid: Faker::Internet.user_name(6..7),
    source: Faker::Internet.user_name(6..7)
  )
end

# 100.times do
#   Vote.create(
#     text: Faker::Lorem.sentence(rand(2..10)).chomp('.'),
#     netid: Faker::Internet.user_name(6..7),
#     source: Faker::Internet.user_name(6..7)
#   )
# end