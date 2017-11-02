class StreamTweets
  attr_reader :client

  def initialize(handle: 'realDonaldTrump' )
    @client = initialize_streaming_client
  end

  def add_new_tweets_to_db
    trump_id = 25073877
    # follows all tweets, mentions, rt related to trump
    client.filter(follow: "#{64920676}") do |tweet|
      # if it's trump tweeting from his account add it to the db
      if tweet.user.id == 64920676 && tweet.is_a?(Twitter::Tweet) #|| object.user.id == 64920676 #my acct
        Tweet.create do |t|
          t.content = tweet.full_text
          t.date = tweet.created_at
          t.sentiment_score = AnalyzeSentiment.new.score(tweet.full_text)
        end
      end
    end
  end

  private
    def initialize_streaming_client
      Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV['API_KEY']
        config.consumer_secret     = ENV['API_SECRET']
        config.access_token        = ENV['TOKEN']
        config.access_token_secret = ENV['TOKEN_SECRET']
      end
    end
end

# rake task. run it when app starts
# websockets pg trigger when row // pole from js - make a request setinterval loop loop.
