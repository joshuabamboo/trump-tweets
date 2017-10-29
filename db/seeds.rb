# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


tweets = GetTweets.new.timeline

tweets.each do |tweet|
  Tweet.create do |t|
    t.content = tweet.full_text
    t.date = tweet.created_at
  end
end
