class Tweet < ApplicationRecord
  def self.new_from_twitter(tweet)
    formatted_text = tweet.attrs[:full_text].gsub('&amp;', '&')
    self.create do |t|
      t.content = formatted_text
      t.date = tweet.created_at
      t.sentiment_score = AnalyzeSentiment.new.score(formatted_text)
      t.reply_count = ScrapeReplies.new(tweet.url.to_s).reply_count
      t.retweet_count = tweet.retweet_count
      t.retweet = tweet.retweet?
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

  def self.daily_negatives
    todays_tweets.select {|t| t.sentiment_score < 0}
  end

  def reply_to_retweet_ratio
    reply_count / retweet_count
  end
end
