class GetTweets
  attr_reader :client, :handle

  def initialize(handle: 'realDonaldTrump' )
    @client = initialize_rest_client
    @handle = handle
  end

  def timeline
    client.user_timeline(handle, tweet_mode: 'extended')
  end

  def user_timeline_since(since_id)
    client.user_timeline(handle, since_id: since_id, tweet_mode: 'extended')
  end

  def recent_activity
    client.user_timeline(handle, tweet_mode: 'extended', since_id: Tweet.maximum('twitter_id'))
  end

  def by_id(id)
    client.status(id, tweet_mode: 'extended')
  end

  private
    def initialize_rest_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['API_KEY']
        config.consumer_secret     = ENV['API_SECRET']
        config.access_token        = ENV['TOKEN']
        config.access_token_secret = ENV['TOKEN_SECRET']
      end
    end
end
