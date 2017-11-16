class Tweet < ApplicationRecord

  def self.new_from_twitter(tweet)
    self.create do |t|
      t.content = tweet.full_text
      t.date = tweet.created_at
      t.sentiment_score = AnalyzeSentiment.new.score(tweet.full_text)
      t.twitter_id = tweet.id
    end
  end

  def self.todays_tweets
    self.where('date > ?', 1.day.ago)
  end

  def self.daily_average
    tweets = todays_tweets
    tweets.sum {|tweet| tweet.sentiment_score} / tweets.size if !tweets.empty?
  end

  def self.latest
    self.order('twitter_id DESC').first
  end

  def self.daily_worst
    todays_tweets.order('sentiment_score').first
  end
end
