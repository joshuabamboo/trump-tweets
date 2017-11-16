namespace :twitter do
  desc 'ping The Donald\'s twitter to look for new tweets'
  task :check_for_new_tweets => :environment do
    new_tweets = GetTweets.new.recent_activity
    if new_tweets.present?
      new_tweets.each { |tweet| Tweet.new_from_twitter(tweet) }
      puts "added #{new_tweets.length} new tweet(s)"
    else
      puts 'No new tweets'
    end
  end
  # Config for Streaming API
  # desc "listen for and add new tweets to db"
  # task :stream => :environment do
  #   StreamTweets.new.listen
  # end
end
