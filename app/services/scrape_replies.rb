require 'net/http'

class ScrapeReplies
  attr_reader :page

  def initialize(url)
    uri = URI(url)
    @page = Net::HTTP.get(uri)
  end

  def reply_count
    if results = page.match(/ProfileTweet-actionCount.+\d+/)
      results[0].gsub(/[^0-9]/, '')
    end
  end
end
