class StreamTweets
  attr_reader :client

  def initialize(handle: 'realDonaldTrump' )
    @client = initialize_streaming_client
  end

  def listen
    trump_id = 25073877
    # follows all tweets, mentions, rt related to trump
    client.filter(follow: "#{trump_id}") do |tweet|
      # if it's trump tweeting from his account add it to the db
      if tweet.user.id == trump_id && tweet.is_a?(Twitter::Tweet) #|| object.user.id == 64920676 #my acct
        Tweet.new_from_twitter(tweet)
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
