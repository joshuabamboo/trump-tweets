namespace :tweet do
  desc "listen for and add new tweets to db"
  task :stream => :environment do
    StreamTweets.new.add_new_tweets_to_db 
  end
end
