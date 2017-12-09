require 'net/http'

class ScrapeReplies
  attr_reader :page

  def initialize(url)
    uri = URI(url)
    @page = Net::HTTP.get(uri)
  end

  def reply_count
    if results = page.match(/data-tweet-stat-count=..\d*/)
      results[0].gsub(/data-tweet-stat-count=\"/, '')
    end
  end
end
