require 'net/http'

class ScrapeReplies
  attr_reader :page, :tweet_id

  def initialize(url, tweet_id)
    uri = URI(url)
    @tweet_id = tweet_id
    @page = Net::HTTP.get(uri)
  end

  def reply_count
    if results = page.match(/profile-tweet-action-reply-count-aria-#{tweet_id}.+\d+/)
      results[0].gsub(/[^0-9]/, '').gsub("#{tweet_id}",'')
    end
  end
end
