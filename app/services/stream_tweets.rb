class StreamTweets
  attr_reader :client

  def initialize(handle: 'realDonaldTrump' )
    @client = initialize_streaming_client
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
