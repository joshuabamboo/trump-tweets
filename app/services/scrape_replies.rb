require 'net/http'

class ScrapeReplies
  attr_reader :page, :tweet_id, :retweet

  def initialize(url, tweet_id, retweet)
    uri = URI(url)
    @tweet_id = tweet_id
    @retweet = retweet
    @page = Net::HTTP.get(uri)
  end

  def reply_count
    if results = page.match(/profile-tweet-action-reply-count-aria-#{tweet_id}.+\d+/)
      results[0].gsub(/[^0-9]/, '').gsub("#{tweet_id}",'')
    elsif retweet
      redirect_url = page.match(/https:\/\/twitter.com\/.+status\/\d+/)[0]
      redirect_tweet_id = page.match(/status\/\d+/)[0].gsub(/[^0-9]/,'')
      uri = URI(redirect_url)
      @page = Net::HTTP.get(uri)
      if results = page.match(/profile-tweet-action-reply-count-aria-#{redirect_tweet_id}.+\d+/)
        r=results[0].gsub(/[^0-9]/, '').gsub("#{redirect_tweet_id}",'')
      end
    end
  end
end
