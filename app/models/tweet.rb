class Tweet < ApplicationRecord
  def self.from_today
    self.where('date > ?', 1.day.ago)
  end

  def self.daily_average
    tweets = self.from_today
    tweets.sum {|tweet| tweet.sentiment_score} / tweets.size if !tweets.empty?
  end

end
